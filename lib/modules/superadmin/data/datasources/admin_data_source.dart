import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/superadmin/data/models/admin_model.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/admin_entity.dart';
abstract class AdminDataSource {
  Future<AdminEntity> postAdmin(AdminModel model);
}

class AdminDataSourceImpl implements AdminDataSource {
  final DioClient dioClient;

  AdminDataSourceImpl({required this.dioClient});

  @override
  Future<AdminEntity> postAdmin(AdminModel model) async {
    try {
      final response = await dioClient.dio.post(
        '/api/admin/register',
        data: model.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Accede directamente a los datos importantes: 'status', 'message' y 'error'
        final responseData = response.data;

        if (responseData != null) {
          // Puedes verificar el campo 'status' o 'message' dependiendo de lo que necesites
          if (responseData['error'] == false) {
            // Si no hay error, puedes devolver una respuesta de éxito
            return AdminEntity(status: responseData['status']);
          } else {
            throw Exception('Error al registrar el administrador: ${responseData['message']}');
          }
        } else {
          throw Exception('No data found in the response');
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      throw Exception('Error posting admin: $e');
    }
  }
}
