import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/auth/data/exceptions/code_exceptions.dart';
import 'package:sigede_movil/modules/auth/data/models/code_confirmation_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/code_confirmation_entity.dart';

abstract class CodeConfirmationDataSource {
  Future<CodeConfirmationEntity> codeConfirmation(
      CodeConfirmationModel codeConfirmationModel);
}

class CodeConfirmationDataSourceImpl implements CodeConfirmationDataSource {
  final DioClient dioClient;

  CodeConfirmationDataSourceImpl({required this.dioClient});

  @override
  Future<CodeConfirmationEntity> codeConfirmation(CodeConfirmationModel model) async {
    try {
      final response = await dioClient.dio.post(
        '/api/recovery-password/validate-verification-code',
        data: model.toJson(),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return CodeConfirmationModel.fromJson(response.data);
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
          case 401:
            throw InvalidCodeException();
          case 410:
            throw CodeExpiredException();
          case 500:
            throw ServerException();
          default:            
            final customCode = dioError.response?.data['code'] as int?;
            if (customCode != null) {
              switch (customCode) {
                case 1001:
                  throw CodeVerificationException();
                case 1003:
                  throw InvalidCodeException();
                case 1004:
                  throw CodeExpiredException();
              }
            }            
            throw UnexpectedException();
        }
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
