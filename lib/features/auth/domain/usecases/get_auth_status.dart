import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';
import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';

class GetAuthStatus {
  final AuthRepository repository;

  GetAuthStatus(this.repository);

  Stream<UserEntity> call() {
    return repository.user;
  }
}