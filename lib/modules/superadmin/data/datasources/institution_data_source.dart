import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/superadmin/data/models/institution_model.dart';

abstract class InstitutionDataSource {
  Future<InstitutionResponseModel> getInstitutionsByName(
      String name, int page, int size);
}

class InstitutionDataSourceImpl implements InstitutionDataSource {
  final DioClient dioClient;

  InstitutionDataSourceImpl({required this.dioClient});

  @override
  Future<InstitutionResponseModel> getInstitutionsByName(
      String name, int page, int size) async {
    try {
      final response = await dioClient.dio.post(
        '/api/institutions/get-institutions-by-name',
        data: {
          'name': name,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return InstitutionResponseModel.fromJson(response.data);
      } else {
        throw DioError(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      throw Exception('Error fetching institutions: $e');
    }
  }
}
