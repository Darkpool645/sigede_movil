import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/superadmin/data/models/institution_new_model.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/institutions_entity.dart';

abstract class InstitutionPostDataSource {
  Future<InstitutionsEntity> postInstitution(InstitutionNewModel model);
}

class InstitutionPostDataSourceImpl implements InstitutionPostDataSource {
  final DioClient dioClient;

  InstitutionPostDataSourceImpl({required this.dioClient});

  @override
  Future<InstitutionsEntity> postInstitution(InstitutionNewModel model) async {
    try {
      final response = await dioClient.dio.post(
        '/api/institutions/post-institution',
        data: model.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final responseData = response.data['data']; // Extrae 'data'
        return InstitutionsEntity.fromJson(responseData);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      throw Exception('Error posting institution: $e');
    }
  }
}
