import 'package:flutter/cupertino.dart';
import 'package:mynotes/utility/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog (BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We have now sent you a password reset link. Please check your email for more information',
    optionsBuilder:() => {
      'OK' : null,
    },
  );
}