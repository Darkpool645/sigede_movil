import 'package:sigede_movil/modules/auth/data/datasources/recovery_password_data_source.dart';
import 'package:sigede_movil/modules/auth/data/models/recovery_password_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/recovery_password_entity.dart';

abstract class RecoveryPasswordRepository {
  Future<RecoveryPasswordEntity> recoveryPassword(RecoveryPasswordModel model);
}

class RecoveryPasswordRepositoryImpl implements RecoveryPasswordRepository{
  final RecoveryPasswordRemoteDataSource recoveryPasswordRemoteDataSource;

  RecoveryPasswordRepositoryImpl({required this.recoveryPasswordRemoteDataSource});

  @override
  Future<RecoveryPasswordEntity> recoveryPassword(RecoveryPasswordModel model) async {
    return await recoveryPasswordRemoteDataSource.recoveryPassword(model);
  }
}