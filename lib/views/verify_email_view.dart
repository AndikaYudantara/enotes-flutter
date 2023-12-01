import 'package:e_notes/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
          const Text('Please verify your email address'),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                devtools.log('Verifikasi berhasil');
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                devtools.log(e.toString());
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
