import 'package:flutter/cupertino.dart';
import 'package:mynotes/utility/dialogs/generic_dialog.dart';

Future<void> showErrorDialog (BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occur',
    content: text,
    optionsBuilder: () => {
    'OK' : null,
   });
}