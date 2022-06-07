import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utility/show_error.dart';


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
    return Scaffold(appBar:AppBar(
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
              TextButton(onPressed: () async {
            
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                  );
    
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifiedemailRoute,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              }
                on FirebaseAuthException catch (e){
                  if (e.code == 'weak-password'){
                  await showErrorDialog(
                    context, 
                    'Weak Password',
                    );
                   }
                 else if (e.code == 'invalid-email'){
                  await showErrorDialog(
                    context,
                   'Invalid Email',
                  );
                }
                else if (e.code == 'email-already-in-use'){
                  await showErrorDialog(
                    context,
                    'Email already in use',
                    );
                  }
                else{
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}',
                    );
                  }
                }
                 catch (e){
                  await showErrorDialog(
                    context,
                  e.toString(),
                  );
                }
              },
              child: const Text('register'),
              ),
            TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
              );
            },
            child: const Text('Already Have an account? Login',
            ),
          ),
        ],
      ),
    );
  } 
}