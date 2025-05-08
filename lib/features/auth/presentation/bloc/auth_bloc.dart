import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';
import 'package:peer_connects/features/auth/domain/usecases/get_auth_status.dart';
import 'package:peer_connects/features/auth/domain/usecases/reset_password.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_out.dart';
import 'package:peer_connects/features/auth/domain/usecases/sign_up.dart';
import 'package:peer_connects/features/auth/presentation/bloc/auth_event.dart';
import 'package:peer_connects/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAuthStatus _getAuthStatus;
  final SignUp _signUp;
  final SignInWithEmailAndPassword _signInWithEmailAndPassword;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final ResetPassword _resetPassword;

  StreamSubscription? _authStatusSubscription;

  AuthBloc({
    required GetAuthStatus getAuthStatus,
    required SignUp signUp,
    required SignInWithEmailAndPassword signInWithEmailAndPassword,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required ResetPassword resetPassword,
  })  : _getAuthStatus = getAuthStatus,
        _signUp = signUp,
        _signInWithEmailAndPassword = signInWithEmailAndPassword,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _resetPassword = resetPassword,
        super(const AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignInWithEmailRequested>(_onAuthSignInWithEmailRequested);
    on<AuthSignInWithGoogleRequested>(_onAuthSignInWithGoogleRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    _authStatusSubscription?.cancel();
    _authStatusSubscription = _getAuthStatus().listen(
      (user) {
        if (user == UserEntity.empty) {
          emit(const AuthState.unauthenticated());
        } else {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _signUp(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      // Auth state will be updated by the stream
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onAuthSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // Auth state will be updated by the stream
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onAuthSignInWithGoogleRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _signInWithGoogle();
      // Auth state will be updated by the stream
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _signOut();
      // Auth state will be updated by the stream
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _resetPassword(event.email);
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStatusSubscription?.cancel();
    return super.close();
  }
}