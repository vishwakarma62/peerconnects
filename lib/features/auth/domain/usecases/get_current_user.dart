import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';
import 'package:peer_connects/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  UserEntity call() {
    return repository.currentUser;
  }
}