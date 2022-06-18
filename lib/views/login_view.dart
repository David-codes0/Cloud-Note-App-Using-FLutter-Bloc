
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
// import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';



class Loginview extends StatefulWidget {
  const Loginview({Key? key}) : super(key: key);

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
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
  return Scaffold( appBar:
   AppBar(title: const Text('Login'),
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
                
                try{
                  context.read<AuthBloc>().add(
                    AuthEventLogIn(
                        email, 
                        password,
                      ),
                    );
              }on UserNotFoundAuthException {
                await showErrorDialog(
                context,
                'User not found',
                );
              }
              on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong Password',
                  );
               }
              on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication Error');
              }  
             
            },
              child: const Text('Login'),
              ),
              TextButton(onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute,
                (route) => false);
              },
            child: const  Text('Not registered yet? Register')
          ),
        ],
      ),
    );
  }
}
