import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/generic_dialog.dart';
import 'package:mynotes/widgets/app_custom_button.dart';
import 'package:mynotes/widgets/app_styles.dart';
class VerifiedEmailView extends StatefulWidget {
  const VerifiedEmailView({Key? key}) : super(key: key);

  @override
  State<VerifiedEmailView> createState() => _VerifiedEmailViewState();
}

class _VerifiedEmailViewState extends State<VerifiedEmailView> {
  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // ignore: unnecessary_type_check
        if (state is AuthStateEmailAlreadySent) {
           showGenericDialog(
    context: context,
    title: 'Verifying Email',
    content: 'Email Already Sent!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
        }
      },
      child: Scaffold(
        backgroundColor: kAppBackground,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Verify Email',
            style: GoogleFonts.nunito(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(
              color: kDarkWhiteColor,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/green-checkmark-icon.svg'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'We\'ve sent you an email verification. please open it to verify your account\nif you haven\'t recieved a verification email yet, press the button below',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.pacifico(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF474747),
                      ),
                    ),
                  ),
                ),
                AuthButton(
                  buttonName: 'Send Email Verification',
                  onPressed: () async {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                ),
                AuthButton(
                  buttonName: '<< go to login page',
                  onPressed: () async {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
