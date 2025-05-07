import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<void> call(String email) async {
    return await repository.resetPassword(email);
  }
}