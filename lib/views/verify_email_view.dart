
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';

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
      body: SingleChildScrollView(
        child: Column(
              children: [
                const Text('We\'ve sent you an email verification. please open it to verify your account '),
                const Text('if you haven\'t recieved a verification email yet, press the button below '),
                TextButton(
                onPressed:() async {
                  context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                },
                child: const Text('Send Email Verification'),
                
              ),
                 TextButton(
                onPressed:() async {
                  // ignore: use_build_context_synchronously
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Restart'),
                
              ),  
            ],
          ),
      ),
    );
  }
}