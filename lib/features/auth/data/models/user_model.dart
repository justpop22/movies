import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/enitiy/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.phoneNumber,
    super.avatarId,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? "",
      displayName: user.displayName ?? "",
      phoneNumber: user.phoneNumber,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? "",
      email: json['email'] ?? "",
      displayName: json['name'] ?? "",
      phoneNumber: json['phone'],
      avatarId: json['avatarId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': displayName,
      'phone': phoneNumber,
      'avatarId': avatarId,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    int? avatarId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}
