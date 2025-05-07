import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
  });

  /// Creates a [UserModel] from a Firebase user.
  factory UserModel.fromFirebase(dynamic firebaseUser) {
    return UserModel(
      id: firebaseUser.uid ?? '',
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Creates a [UserModel] from a Firestore document.
  factory UserModel.fromFirestore(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'] ?? '',
      email: doc['email'] ?? '',
      name: doc['name'],
      photoUrl: doc['photoUrl'],
    );
  }

  /// Converts the [UserModel] to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  /// Creates a copy of the [UserModel] with the given fields replaced.
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}