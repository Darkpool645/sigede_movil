import 'package:sigede_movil/modules/admin/data/datasources/capturista_remote_data_source.dart';
import 'package:sigede_movil/modules/admin/data/models/capturista.dart';
import 'package:sigede_movil/modules/admin/data/models/simple_capturista.dart';

abstract class CapturistaRepository {
  Future<List<SimpleCapturista>> getAllCapturistas({
    required int institutionId,
  });
  Future<Capturista> getCapturista({
    required int userId
  });
  Future<dynamic> createCapturista({required String name, required String email, required int fkInstitution});
  Future<dynamic> updateCapturista({required int userId, required String name});
  Future<dynamic> disableCapturista({required String email, required String status});
}

class CapturistaRepositoryImpl implements CapturistaRepository {
  final CapturistaRemoteDataSource capturistaRemoteDataSource;

  CapturistaRepositoryImpl({required this.capturistaRemoteDataSource});

  @override
  Future<List<SimpleCapturista>> getAllCapturistas({
    required int institutionId,
  }) async {
    return await capturistaRemoteDataSource.getAllCapturistas(
      institutionId: institutionId,
    );
  }

  @override
  Future<Capturista> getCapturista({
    required int userId
  }) async {
    return await capturistaRemoteDataSource.getCapturista(
      userId:userId
    );
  }

  @override
  Future<dynamic> createCapturista({required String name, required String email, required int fkInstitution}) async {
    return await capturistaRemoteDataSource.createCapturista(name: name, email: email, fkInstitution: fkInstitution);
  }

  @override
  Future<dynamic> updateCapturista({required int userId, required String name}) async {
    return await capturistaRemoteDataSource.updateCapturista(userId: userId, name: name);
  }

  @override
  Future<dynamic> disableCapturista({required String email, required String status}) async {
    await capturistaRemoteDataSource.disableCapturista(email: email, status: status);
  }
}
