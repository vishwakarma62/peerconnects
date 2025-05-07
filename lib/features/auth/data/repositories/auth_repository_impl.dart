import 'package:peer_connects/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';
import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  UserEntity get currentUser => _datasource.currentUser;

  @override
  Future<void> resetPassword(String email) async {
    await _datasource.resetPassword(email);
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _datasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    await _datasource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await _datasource.signUp(
      email: email,
      password: password,
      name: name,
    );
  }

  @override
  Stream<UserEntity> get user => _datasource.authStateChanges;
}