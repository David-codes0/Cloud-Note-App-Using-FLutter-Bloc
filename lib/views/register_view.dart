import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';

import '../services/auth/auth_service.dart';

class Registerview extends StatefulWidget {
  const Registerview({Key? key}) : super(key: key);

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
       if(state is AuthStateRegistering){
        if(state.exception is WeakPasswordAuthException) {
          await showErrorDialog(context,'Weak Password',);
        }
        else if(state.exception is InvalidEmailAuthException){
          await showErrorDialog(context,'Invalid Email',);
        }
       else if(state.exception is EmailAlreadyInUseAuthException){
          await showErrorDialog(context, 'Email already in use');
        }
        else if(state.exception is GenericAuthException ){
          await showErrorDialog(context, 'Failed to register');
        }
       }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
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
                context.read<AuthBloc>().add(AuthEventRegister(
                  email,
                  password,
                ));
              },
              child: const Text('register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text(
                'Already Have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
