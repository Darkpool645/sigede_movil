import 'package:sigede_movil/features/authentication/domain/entities/recovery_password_entity.dart';

class RecoveryPasswordModel extends RecoveryPasswordEntity {
  RecoveryPasswordModel({
    super.error,
    super.userEmail,
    super.data
  });

  factory RecoveryPasswordModel.fromJson(Map<String, dynamic> json) {
    return RecoveryPasswordModel(
      error: json['error'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
    };
  }
}