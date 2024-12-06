import 'package:sigede_movil/modules/capturista/data/models/credential_model.dart';
import 'package:sigede_movil/modules/capturista/data/repositories/credential_repository.dart';

class GetCredentials {
  final CredentialRepository repository;

  GetCredentials({required this.repository});

  Future<List<CredentialModel>> call({
    required int institutionId
  }){
    return repository.getAllCredentials(institutionId: institutionId);
  }
}