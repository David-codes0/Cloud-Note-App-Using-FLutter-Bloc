import 'package:flutter/material.dart';
import 'package:mynotes/widgets/app_styles.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        minimumSize: const Size(
          250,
          30,
        ),
        primary: kPurpleColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(buttonName),
    );
  }
}
