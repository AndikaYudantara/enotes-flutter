import 'package:bloc/bloc.dart';
import 'package:e_notes/services/auth/auth_provider.dart';
import 'package:e_notes/services/auth/bloc/auth_event.dart';
import 'package:e_notes/services/auth/bloc/auth_state.dart';
// ignore: unused_import
import 'dart:developer' as devtools show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoggedOut(null)) {
    // initialize
    on<AuthEventInitalize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // login
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });

    // logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(const AuthStateLoading());
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
