// import 'dart:html';

import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/services/auth/bloc/onboard_bloc_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/onboarding/pages/onboarding_page.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/thank_youpage.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:path_provider/path_provider.dart';

import 'views/notes/notes_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Note App',
      debugShowMaterialGrid: false,
      home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(FirebaseAuthProvider()),
            ),
            BlocProvider(
              create: (context) => OnboardBlocBloc(),
            )
          ],
          child: BlocBuilder<OnboardBlocBloc, OnboardBlocState>(
            builder: (context, state) {
              // final seenOnBoardBool = (state is SeenOnBoardState) ? false : true;
              if (state is SeenOnBoardState) {
                devtools.log('${state.seenOnboard}');
                return state.seenOnboard
                    ? const OnboardingPage()
                    : const Homepage();
              } else {
                return const Homepage();
              }
            },
          )),
      debugShowCheckedModeBanner: false,
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    )),
    storage: storage,
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification ||
            state is AuthStateEmailAlreadySent) {
          return const VerifiedEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const Loginview();
        } else if (state is AuthStateRegistering) {
          return const Registerview();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPassword();
        } else {
          return const Scaffold(
            body: AppProgressIndicator(),
          );
        }
      },
    );
    //
  }
}

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      child: const Center(
        child: SizedBox(
          height: 400,
          width: 400,
          child: LottieAni(),
        ),
      ),
    );
  }
}


