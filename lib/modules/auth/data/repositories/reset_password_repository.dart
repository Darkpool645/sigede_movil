import 'package:sigede_movil/modules/auth/data/datasources/reset_password_data_source.dart';
import 'package:sigede_movil/modules/auth/data/models/reset_password_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/reset_password_entity.dart';

abstract class ResetPasswordRepository {
  Future<ResetPasswordEntity> resetPassword(ResetPasswordModel resetPasswordModel);
}

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  final ResetPasswordDataSource resetPasswordDataSource;

  ResetPasswordRepositoryImpl({required this.resetPasswordDataSource});

  @override
  Future<ResetPasswordEntity> resetPassword(ResetPasswordModel model) async {
    return await resetPasswordDataSource.resetPassword(model);
  }
}