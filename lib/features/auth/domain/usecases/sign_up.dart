import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<void> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      name: name,
    );
  }
}