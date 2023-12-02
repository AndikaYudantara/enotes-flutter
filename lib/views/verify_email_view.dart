import 'package:e_notes/constants/routes.dart';
import 'package:e_notes/utilities/show_alert_dialog.dart';
import 'package:e_notes/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "we've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you haven't recived a verification email yet, use the button below."),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                if (!mounted) return;
                showAlertDialog(context, 'Email verification sended!');
              } on FirebaseAuthException catch (e) {
                if (!mounted) return;
                showErrorDialog(context, 'Error : ${e.code}');
              }
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (_) => false,
              );
            },
            child: const Text('Back to login'),
          ),
        ],
      ),
    );
  }
}
