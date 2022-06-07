import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class VerifiedEmailView extends StatefulWidget {
  const VerifiedEmailView({Key? key}) : super(key: key);

  @override
  State<VerifiedEmailView> createState() => _VerifiedEmailViewState();
}

class _VerifiedEmailViewState extends State<VerifiedEmailView> {
  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
    ),
      body: Column(
            children: [
              const Text('We\'ve sent you an email verification. please open it to verify your account '),
              const Text('if you haven\'t recieved a verification email yet, press the button below '),
               TextButton(
              onPressed:() async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute,
                (route) => false,
                );
              },
              child: const Text('Restart'),
              
            ),  
              TextButton(
              onPressed:() async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text('Send Email Verification'),
              
            ),

          ],
        ),
    );
  }
}