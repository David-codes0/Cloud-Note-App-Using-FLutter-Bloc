import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              const Text('Please  verify your email address:'),  
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