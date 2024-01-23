import 'package:e_notes/services/auth/bloc/auth_bloc.dart';
import 'package:e_notes/services/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
                "we've sent you an email verification. Please open it to verify your account."),
            const Text(
                "If you haven't recived a verification email yet, use the button below."),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text('Send email verification'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }
}
