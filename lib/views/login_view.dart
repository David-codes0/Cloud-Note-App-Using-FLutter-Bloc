import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import 'package:mynotes/services/auth/auth_exceptions.dart';
// import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';
import 'package:mynotes/utility/dialogs/loading_dialog.dart';


class Loginview extends StatefulWidget {
  const Loginview({Key? key}) : super(key: key);

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandler;


  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {


        final closeDialog = _closeDialogHandler;
       if (state is AuthStateLoggedOut) {
          if (!state.isLoading && closeDialog != null){
            closeDialog();
            _closeDialogHandler = null;
          }else if(state.isLoading && closeDialog == null){
           _closeDialogHandler = showLoadingDialog(
            context: context,
            text: 'Loading..');
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context,'User not found');
          }
          if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          }
          if (state.exception is GenericAuthException) {
            await showErrorDialog(context,'Authentication Error',);
          }
      }
    },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              autocorrect: false,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventShouldRegister()
                  );
                },
                child: const Text('Not registered yet? Register')),
          ],
        ),
      ),
    );
  }
}
