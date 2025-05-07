import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<void> call() async {
    return await repository.signInWithGoogle();
  }
}