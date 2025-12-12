class UserEntity {
  final String uid;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final int? avatarId;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.avatarId,
  });

  @override
  List<Object?> get props => [uid, email, displayName, phoneNumber, avatarId];
}
