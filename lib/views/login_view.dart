import 'package:e_notes/constants/routes.dart';
import 'package:e_notes/unitilies/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (userCredential.user?.emailVerified ?? false) {
                  devtools.log('Login Success!');
                  if (!mounted) return;
                  Navigator.of(context).restorablePushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  if (!mounted) return;
                  await showErrorDialog(context, 'Email not verified');
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  if (!mounted) return;
                  await showErrorDialog(context, 'User not found!');
                } else if (e.code == 'wrong-password') {
                  if (!mounted) return;
                  await showErrorDialog(context, 'Wrong password!');
                } else {
                  if (!mounted) return;
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                if (!mounted) return;
                await showErrorDialog(context, e.toString());
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
