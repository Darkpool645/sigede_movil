import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/auth/data/exceptions/reset_password_exceptions.dart';
import 'package:sigede_movil/modules/auth/data/models/reset_password_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/reset_password_entity.dart';

abstract class ResetPasswordDataSource {
  Future<ResetPasswordEntity> resetPassword(ResetPasswordModel resetPasswordModel);
}

class ResetPasswordDataSourceImpl implements ResetPasswordDataSource{
  final DioClient dioClient;

  ResetPasswordDataSourceImpl({required this.dioClient});

  @override
  Future<ResetPasswordEntity> resetPassword(ResetPasswordModel model) async {
    try {
      final response = await dioClient.dio.put(
        '/api/recovery-password/change-password',
        data: model.toJson(),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return ResetPasswordModel.fromJson(response.data);
      } else {
        // Aquí puedes manejar la respuesta de error, si el código no es exitoso
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        switch (dioError.response?.statusCode) {
          case 400:
            throw BadRequestException();
          case 404:
            throw UserNotFoundException();          
          case 500:
            throw ServerException();
          default:
            throw ResetPasswordExceptions('Unexpected error: ${dioError.response?.statusCode}');
        }
      } else {
      throw Exception('Network error: ${dioError.message}');
    }
    } catch (e) {
    
    throw Exception('Unexpected error: ${e.toString()}');
  }
  }
}