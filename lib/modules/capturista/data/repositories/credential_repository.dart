import 'package:sigede_movil/modules/capturista/data/datasources/credential_remote_data_source.dart';
import 'package:sigede_movil/modules/capturista/data/models/credential_model.dart';

abstract class CredentialRepository {
  Future<List<CredentialModel>> getAllCredentials({
    required int institutionId,
  });

  Future<CredentialModel> getCredential({
    required int credentialId,
  });

  // Future<dynamic> createCredential({
  //   required String fullname,
  //   required String userPhoto,
  //   required String expirationDate,
  //   required int institutionId,
  // });

  // Future<dynamic> updateCredential({
  //   required int credentialId,
  //   required String fullname,
  //   required String userPhoto,
  //   required String expirationDate,
  // });

  Future<dynamic> deleteCredential({
    required int credentialId,
  });
}

class CredentialRepositoryImpl implements CredentialRepository {
  final CredentialRemoteDataSource credentialRemoteDataSource;

  CredentialRepositoryImpl({required this.credentialRemoteDataSource});

  @override
  Future<List<CredentialModel>> getAllCredentials({
    required int institutionId,
  }) async {
    return await credentialRemoteDataSource.getAllCredentials(
      institutionId: institutionId,
    );
  }

  @override
  Future<CredentialModel> getCredential({
    required int credentialId,
  }) async {
    return await credentialRemoteDataSource.getCredential(
      credentialId: credentialId,
    );
  }

  // @override
  // Future<dynamic> createCredential({
  //   required String fullname,
  //   required String userPhoto,
  //   required String expirationDate,
  //   required int institutionId,
  // }) async {
  //   return await credentialRemoteDataSource.createCredential(
  //     fullname: fullname,
  //     userPhoto: userPhoto,
  //     expirationDate: expirationDate,
  //     fkInstitution: institutionId,
  //   );
  // }

  // @override
  // Future<dynamic> updateCredential({
  //   required int credentialId,
  //   required String fullname,
  //   required String userPhoto,
  //   required String expirationDate,
  // }) async {
  //   return await credentialRemoteDataSource.updateCredential(
  //     credentialId: credentialId,
  //     fullname: fullname,
  //     userPhoto: userPhoto,
  //     expirationDate: expirationDate,
  //   );
  // }

  @override
  Future<dynamic> deleteCredential({
    required int credentialId,
  }) async {
    return await credentialRemoteDataSource.deleteCredential(
      credentialId: credentialId,
    );
  }
}
