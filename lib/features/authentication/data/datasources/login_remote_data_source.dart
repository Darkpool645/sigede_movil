import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/features/authentication/data/exceptions/auth_exceptions.dart';
import 'package:sigede_movil/features/authentication/data/models/login_model.dart';
import 'package:sigede_movil/features/authentication/domain/entities/login_entity.dart';

abstract class LoginRemoteDataSource{
  Future<LoginEntity> login(LoginModel loginModel);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LoginEntity> login(LoginModel loginModel) async {
    try {
      final response = await dioClient.dio.post(
        '/login',
        data: loginModel.toJson(),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return LoginModel.fromJson(response.data); // Mapea los datos correctamente
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (dioError) {
      // Manejo de errores basado en el statusCode
      if (dioError.response != null) {
        switch (dioError.response?.statusCode) {
          case 400:
            throw BadRequestException();
          case 401:
            throw InvalidCredentialsException();
          case 404:
            throw UserNotFoundException();
          case 500:
            throw ServerException();
          default:
            throw AuthException('Error inesperado: ${dioError.response?.statusCode}');
        }
      } else {
        throw Exception('Error de red: ${dioError.message}');
      }
    }
  }
}
