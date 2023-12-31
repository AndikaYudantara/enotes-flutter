import 'package:e_notes/constants/routes.dart';
import 'package:e_notes/services/auth/auth_exceptions.dart';
import 'package:e_notes/services/auth/auth_service.dart';
import 'package:e_notes/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  if (!mounted) return;
                  Navigator.of(context).restorablePushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  if (!mounted) return;
                  await showErrorDialog(context, 'Email not verified');
                  if (!mounted) return;
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'User not found!');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Wrong password!');
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication error}');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}
