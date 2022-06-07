import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';


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
  
              TextButton(onPressed: () async {
            
                final email = _email.text;
                final password = _password.text;
                try{
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute,
                (route) => false,
                );
              }
               on FirebaseAuthException catch (e){
                 if (e.code == 'user-not-found'){
                   devtools.log('User not Found');
                 }
                 else if (e.code == 'wrong-password'){
                  devtools.log('Wrong Password');
                 }
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