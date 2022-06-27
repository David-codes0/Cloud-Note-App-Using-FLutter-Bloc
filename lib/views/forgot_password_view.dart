import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';
import 'package:mynotes/utility/dialogs/password_reset_email.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
   return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
       if (state is AuthStateForgotPassword) {
        if (state.hasSentEmail){
          await showPasswordResetDialog(context);
        }
        if(state.exception != null ){
          await showErrorDialog(context, 
          'We could not process your request. Please make sure your a registered user, or if not, register a user now by going back one step.',
        );
      }

       }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fprgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children : [
              const Text('if you forgot your password, simply enter your email and we will send you a passpwrd'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                autocorrect: false,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Your email address..... '
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                  .read<AuthBloc>()
                  .add(AuthEventForgotPassword(email: email));

                },
                child: const Text('Send me password reset link'),
              ),
              TextButton(
                 onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
                 child: const Text(
                'Back to login page',
              ),
            ),
        

            ]
          ),
        ),
        //
      ),
    );
  }
}