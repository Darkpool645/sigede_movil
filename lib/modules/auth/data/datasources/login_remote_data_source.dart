import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/auth/data/models/login_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/login_entity.dart';

import '../../../../features/authentication/data/exceptions/auth_exceptions.dart';

abstract class LoginRemoteDataSource {
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

    // Verifica que el estado HTTP sea exitoso (200-299)
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return LoginModel.fromJson(response.data);
    } else {
      // Aquí puedes manejar la respuesta de error, si el código no es exitoso
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  } on DioException catch (dioError) {
    // Aquí se maneja el error utilizando la misma lógica que tienes en el interceptor
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
            throw AuthException('Unexpected error: ${dioError.response?.statusCode}');
        }
    } else {
      // En caso de errores de red o conexión
      throw Exception('Network error: ${dioError.message}');
    }
  } catch (e) {
    // Si hay algún otro error no relacionado con Dio
    throw Exception('Unexpected error: ${e.toString()}');
  }
}

}
