import 'package:flutter/material.dart';
import 'package:mynotes/widgets/app_styles.dart';






class OnboardingNavButton extends StatelessWidget {
  const OnboardingNavButton({
    Key? key,
    required this.onPressed,
    required this.name,
    required this.buttonColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String name;
  final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      splashColor: kPurpleColor.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          name,
          style: kTextButton.copyWith(color: buttonColor),
        ),
      ),
    );
  }
}
