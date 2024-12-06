import 'package:sigede_movil/utils/jwt_decoder.dart';
import 'package:sigede_movil/features/authentication/data/datasources/login_remote_data_source.dart';
import 'package:sigede_movil/features/authentication/data/models/login_model.dart';
import 'package:sigede_movil/features/authentication/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> login(LoginModel model);
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;

  LoginRepositoryImpl({
    required this.loginRemoteDataSource
  });

  @override
  Future<LoginEntity> login(LoginModel model) async {
    final loginModel = await loginRemoteDataSource.login(model);

    final token = loginModel.token;
    if (token != null) {
      final role = JwtDecoder.getRoleFromToken(token);
      
      return LoginEntity(
        token: token,
        email: loginModel.email,
        role: role,
        institutionId: loginModel.institutionId,
      );
    } else {
      throw Exception("Token inválido o no presente");
    }
  }
}