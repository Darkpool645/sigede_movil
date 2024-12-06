import 'package:sigede_movil/features/authentication/data/models/recovery_password_model.dart';
import 'package:sigede_movil/features/authentication/data/repositories/recovery_password_repository.dart';
import 'package:sigede_movil/features/authentication/domain/entities/recovery_password_entity.dart';

class RecoveryPassword {
  final RecoveryPasswordRepository repository;

  RecoveryPassword({
    required this.repository
  });

  Future<RecoveryPasswordEntity> call(RecoveryPasswordModel model) async {
    return await repository.recoveryPassword(model);
  }
}