import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';
import 'package:mynotes/utility/dialogs/password_reset_email.dart';
import 'package:mynotes/widgets/app_custom_button.dart';
import 'package:mynotes/widgets/app_styles.dart';
import 'package:mynotes/widgets/app_textfield.dart';

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
          if (state.hasSentEmail) {
            await showPasswordResetDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              context.loc.forgot_password_view_generic_error,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: kAppBackground,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            context.loc.forgot_password,
            style: GoogleFonts.nunito(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
        ),

        body: Center(
          child: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(
              color: kDarkWhiteColor,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    context.loc.forgot_password_view_prompt,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.pacifico(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF474747),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AppTextField(
                    controller: _controller,
                    labelText: 'Your email address..... ',
                    color: Colors.grey,
                    obsecure: false,
                    keyboardType: TextInputType.emailAddress,
                    autoFocus: true),
                const SizedBox(height: 30),
                AuthButton(
                  buttonName: 'Send me password reset link',
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                ),
                AuthButton(
                  buttonName: 'Back to login page',
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                ),
              ],
            ),
          ),
        ),
        //
      ),
    );
  }
}
