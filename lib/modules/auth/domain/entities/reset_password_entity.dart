class ResetPasswordEntity {
  final String? newPassword;
  final int? userId;
  final bool? error;
  ResetPasswordEntity({
    this.newPassword,
    this.userId,
    this.error, 
  });
}