import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
// import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';
import 'package:mynotes/widgets/app_custom_button.dart';
import 'package:mynotes/widgets/app_styles.dart';
import 'package:mynotes/widgets/app_textfield.dart';


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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          }
          if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          }
          if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Authentication Error',
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: kAppBackground,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Login',
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
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      'Enter your email and password to see your notes!'
                     ,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF474747),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppTextField(
                    keyboardType: TextInputType.emailAddress,
                    autoFocus: true,
                    controller: _email,
                    labelText: 'Enter your email',
                    color: Colors.grey,
                    obsecure: false,
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    keyboardType: TextInputType.text,
                    autoFocus: false,
                    controller: _password,
                    labelText: 'Enter your password',
                    color: Colors.grey,
                    obsecure: true,
                  ),
                  const SizedBox(height: 10),
                  AuthButton(
                    buttonName: 'Login',
                    onPressed: () async {
                      final email = _email.text.trim();
                      final password = _password.text.trim();

                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email,
                              password,
                            ),
                          );
                    },
                  ),
                  AuthButton(
                    buttonName: 'Forgot Password ?',
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventForgotPassword());
                    },
                  ),
                  AuthButton(
                    buttonName: 'Not registered yet? Register',
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventShouldRegister());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

