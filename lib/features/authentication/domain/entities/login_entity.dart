class LoginEntity {
  final String email;
  final String? password;
  final String? token;
  final String? role;
  
  LoginEntity({
    required this.email,
    this.password,
    this.token,
    this.role
  });
}