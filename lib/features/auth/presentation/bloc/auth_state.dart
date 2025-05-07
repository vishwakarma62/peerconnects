import 'package:equatable/equatable.dart';
import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity user;
  final String? errorMessage;

  const AuthState._({
    this.status = AuthStatus.initial,
    this.user = UserEntity.empty,
    this.errorMessage,
  });

  const AuthState.initial() : this._();

  const AuthState.authenticated(UserEntity user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated([String? errorMessage])
      : this._(
          status: AuthStatus.unauthenticated,
          errorMessage: errorMessage,
        );

  @override
  List<Object?> get props => [status, user, errorMessage];

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isInitial => status == AuthStatus.initial;
}