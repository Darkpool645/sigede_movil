import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/features/authentication/data/exceptions/recovery_password_exceptions.dart';
import 'package:sigede_movil/features/authentication/data/models/recovery_password_model.dart';
import 'package:sigede_movil/features/authentication/domain/entities/recovery_password_entity.dart';

abstract class RecoveryPasswordRemoteDataSource {
  Future<RecoveryPasswordEntity> recoveryPassword(RecoveryPasswordModel model);
}

class RecoveryPasswordRemoreDataSourceImpl implements RecoveryPasswordRemoteDataSource {
  final DioClient dioClient;

  RecoveryPasswordRemoreDataSourceImpl({
    required this.dioClient
  });

  @override
  Future<RecoveryPasswordEntity> recoveryPassword(RecoveryPasswordModel model) async {
    try{
      final response = await dioClient.dio.post(
        '/api/recovery-password/send-verification-code',
        data: model.toJson(),
      );
      if(response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return RecoveryPasswordModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response
        );
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        switch(dioError.response?.statusCode) {
          case 400:
            throw BadRequestException();
          case 401:
            throw InvalidEmailException();
          case 404:
            throw UserNotFoundException();
          case 500:
            throw ServerException();
          default:
            throw RecoveryPasswordExceptions('Error inesperado: ${dioError.response?.statusCode}');
        }
      } else {
        throw Exception('Error de red: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }
}