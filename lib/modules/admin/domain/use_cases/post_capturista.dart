import 'package:sigede_movil/modules/admin/data/repositories/capturista_repository.dart';

class PostCapturista {
  final CapturistaRepository repository;

  PostCapturista({required this.repository}) ;

  Future<dynamic> call({
    required String name,
    required String email,
    required int fkInstitution
  }) {
    return repository.createCapturista(name: name, email: email, fkInstitution: fkInstitution);
  }
}