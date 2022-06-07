import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';


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
                try {final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, password: password);
    
                  devtools.log(userCredential.toString());
                }
                on FirebaseAuthException catch (e){
                  if (e.code == 'weak-password'){
                   devtools.log('Weak Password');
                 }
                 else if (e.code == 'invalid-email'){
                  devtools.log('Invalid Email');}
                else if (e.code == 'email-already-in-use'){
                  devtools.log('Email already in use');}
                else{
                Navigator.of(context).pushNamedAndRemoveUntil(
              '/verifiedemail/',
              (route) => false);}
                }
              },
              child: const Text('register'),
              ),
            TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
              '/login/',
              (route) => false);},
            child: const Text('Already Have an account? Login'),
            )
          ],
        ),
    );
  } 
}