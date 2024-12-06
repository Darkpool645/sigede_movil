import 'package:sigede_movil/config/dio_client.dart';
import 'package:sigede_movil/modules/admin/data/models/capturista.dart';
import 'package:sigede_movil/modules/admin/data/models/simple_capturista.dart';

abstract class CapturistaRemoteDataSource {
  Future<List<SimpleCapturista>> getAllCapturistas({
    required String role,
    required int institutionId,
  });
  Future<Capturista> getCapturista({required int userId});
  Future<dynamic> createCapturista({required String name, required String email, required int fkInstitution});
  Future<dynamic> updateCapturista({
    required int userId,
    required String name});
  Future<dynamic> disableCapturista({required String email, required String status});
}

class CapturistaRemoteDataSourceImpl implements CapturistaRemoteDataSource {
  final DioClient dioClient;

  CapturistaRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SimpleCapturista>> getAllCapturistas({
    required String role,
    required int institutionId,
  }) async {
    final response = await dioClient.dio.post(
      '/api/users/get-all-by-institution-rolename?page=0&size=10&sort=name,desc',
      data: {
        "role": role,
        "institutionId": institutionId,
      },
    );
    print('LLEGO: ${response}');
    final List<dynamic> data = response.data['data']['content'] ?? [];
    return data.map((json) => SimpleCapturista.fromJson(json)).toList();
  }

  @override
  Future<Capturista> getCapturista({
    required int userId
  }) async {
    final response = await dioClient.dio.get(
      '/api/capturists/get-capturist/$userId',
    );
    print('LLEGO: ${response.data['data']}');
    return Capturista.fromJson(response.data);
  }

  @override
  Future<dynamic> createCapturista({required String name, required String email, required int fkInstitution}) async {
    final response = await dioClient.dio.post(
      '/api/capturists/register',
      data: {
        "name":name,
        "email":email,
        "fkInstitution":fkInstitution
      },
    );
    return response;
  }

  @override
  Future<dynamic> updateCapturista({required int userId, required String name}) async {
    final response = await dioClient.dio.post(
      '/api/users/update-data',
      data: {
        "userId":userId,
        "name":name
      },
    );
    print("LLEGO: $response");
    return response;
  }

  @override
  Future<dynamic> disableCapturista({required String email, required String status}) async {
    print("DESDE datasource: $email, $status");
    await dioClient.dio.post(
      '/api/users/update-status',
      data: {
        "email":email,
        "status":status
      }
    );
  }
}
