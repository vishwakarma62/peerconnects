import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Stream of [UserEntity] which will emit the current user when the authentication state changes.
  /// Emits [UserEntity.empty] if the user is not authenticated.
  Stream<UserEntity> get user;

  /// Creates a new user with the provided [email] and [password].
  /// 
  /// Throws an [Exception] if the registration fails.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Signs in with the provided [email] and [password].
  /// 
  /// Throws an [Exception] if the sign in fails.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs in with Google.
  /// 
  /// Throws an [Exception] if the sign in fails.
  Future<void> signInWithGoogle();

  /// Signs out the current user.
  /// 
  /// Throws an [Exception] if the sign out fails.
  Future<void> signOut();

  /// Returns the current cached user.
  /// 
  /// Throws an [Exception] if there is no cached user.
  UserEntity get currentUser;

  /// Sends a password reset email to the provided [email].
  /// 
  /// Throws an [Exception] if the password reset fails.
  Future<void> resetPassword(String email);
}