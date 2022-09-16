import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/utility/dialogs/error_dialog.dart';
import 'package:mynotes/widgets/app_custom_button.dart';
import 'package:mynotes/widgets/app_styles.dart';
import 'package:mynotes/widgets/app_textfield.dart';


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
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(
                context,
                'Weak Password',
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context,
                'Invalid Email',
              );
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email already in use');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Failed to register');
            }
          }
        },
        child: Scaffold(
          backgroundColor: kAppBackground,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Register',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      'Please Register an  account in other to create notes',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF474747),
                        ),
                      ),
                    ),
                  ),
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
                  Center(
                    child: Column(
                      children: [
                        AuthButton(
                          buttonName: 'register',
                          onPressed: () async {
                            final email = _email.text.trim();
                            final password = _password.text.trim();
                            context.read<AuthBloc>().add(AuthEventRegister(
                                  email,
                                  password,
                                ));
                          },
                        ),
                        AuthButton(
                          buttonName: 'Already Have an account? Login',
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
