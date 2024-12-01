import 'package:dio/dio.dart';
import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/core/models/institution_model.dart';

class InstitutionService {
  final DioClient _dioClient;

  InstitutionService(this._dioClient);

  Future<List<Institution>> fetchInstitutions(int page, int size) async {
    try {
      final response = await _dioClient.dio.get('/api/institution/',
          queryParameters: {'page': page, 'size': size});
      if (response.statusCode == 200) {
        final data = response.data['data']['content'] as List;
        return data.map((json) => Institution.fromJson(json)).toList();
      } else {
        throw Exception(
            'Error al cargar las instituciones: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(
          'Error fetchin institutions in service: ${e.response?.data['message'] ?? 'No se encontraron resultados'}');
    }
  }

  Future<List<Institution>> fetchInstitutionsByName(
      int page, int size, String name) async {
    try{
      final response = await _dioClient.dio.get('/api/institution/getByName',
        queryParameters: { 'content': name, 'page': page, 'size': size}
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['content'] as List;
        return data.map((json) => Institution.fromJson(json)).toList(); 
      } else {
        throw Exception(
          'Error al cargar las instituciones: ${response.statusMessage}'
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(
        'Error fetching institutions in service: ${e.response?.data['message'] ?? 'No se encontraron resultados'}'
      );
    }
  }
}
