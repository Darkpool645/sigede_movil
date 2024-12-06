import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/superadmin/data/exceptions/institutions_all_exceptions.dart';
import 'package:sigede_movil/modules/superadmin/data/models/institutions_model.dart';

abstract class InstitutionsAllDataSource {
  Future<InstitutionsModel> getAllInstitutions();
}

class InstitutionsAllDataSourceImpl implements InstitutionsAllDataSource {
  final DioClient dioClient;

  InstitutionsAllDataSourceImpl({required this.dioClient});
  @override
  Future<InstitutionsModel> getAllInstitutions() async {
    try {
      final response = await dioClient.dio.get('/api/institutions/get-all');

      // Verifica el código de estado de la respuesta
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Deserializa la respuesta en un modelo de tipo InstitutionsModel
        return InstitutionsModel.fromJson(
            response.data); // Aquí se mapea la respuesta
      } else {
        // Si la respuesta no es exitosa, lanza una excepción
        throw DioError(
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
            throw UnauthorizedException();
          case 404:
            throw InstitutionsNotFoundException();
          case 500:
            throw ServerException();
          default:
            throw InstitutionsAllExceptions(
                'Unexpected error: ${dioError.response?.statusCode}');
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
