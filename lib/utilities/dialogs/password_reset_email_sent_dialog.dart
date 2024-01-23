import 'package:e_notes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password reset',
    content:
        'We have now sent you a password reset link. Please check your email.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
