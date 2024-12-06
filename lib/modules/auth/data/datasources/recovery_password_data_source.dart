import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/auth/data/exceptions/recovery_password_exceptions.dart';
import 'package:sigede_movil/modules/auth/data/models/recovery_password_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/recovery_password_entity.dart';

abstract class RecoveryPasswordRemoteDataSource {
  Future<RecoveryPasswordEntity> recoveryPassword(RecoveryPasswordModel model);
}

class RecoveryPasswordRemoteDataSourceImpl implements RecoveryPasswordRemoteDataSource{
  final DioClient dioClient;

  RecoveryPasswordRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RecoveryPasswordEntity> recoveryPassword(RecoveryPasswordModel model) async {
    try {
      final response = await dioClient.dio.post(
        '/api/recovery-password/send-verification-code',
        data: model.toJson(),
      );
      if(response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300){
        return RecoveryPasswordModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (dioError) {
      if(dioError.response != null){
        switch(dioError.response?.statusCode){
          case 400:
            throw BadRequestException();
          case 401:
            throw InvalidEmailException();
          case 404:
            throw UserNotFoundException();
          case 500:
            throw ServerException();
          default:
            throw RecoveryPasswordExceptions('Unexpected error: ${dioError.response?.statusCode}');
        }
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}