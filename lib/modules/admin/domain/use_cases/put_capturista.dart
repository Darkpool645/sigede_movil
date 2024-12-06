import 'package:sigede_movil/modules/admin/data/repositories/capturista_repository.dart';

class PutCapturista {
  final CapturistaRepository repository;

  PutCapturista({required this.repository}) ;

  Future<dynamic> call({
    required int userId,
    required String name
  }) {
    return repository.updateCapturista(userId: userId, name: name);
  }
}