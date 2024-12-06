import 'package:sigede_movil/modules/auth/data/datasources/login_remote_data_source.dart';
import 'package:sigede_movil/modules/auth/data/models/login_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> login(LoginModel model);
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl({required this.loginRemoteDataSource});

  @override
  Future<LoginEntity> login(LoginModel model) async {
    return await loginRemoteDataSource.login(model);
  }
}