class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String repassword;
  final String phone;
  final int avatarId;

  const SignUpParams({
    required this.avatarId,
    required this.name,
    required this.email,
    required this.password,
    required this.repassword,
    required this.phone,
  });
}
