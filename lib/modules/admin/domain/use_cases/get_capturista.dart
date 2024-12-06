import 'package:sigede_movil/modules/admin/data/models/capturista.dart';
import 'package:sigede_movil/modules/admin/data/repositories/capturista_repository.dart';

class GetCapturista {
  final CapturistaRepository repository;

  GetCapturista({required this.repository}) ;

  Future<Capturista> call({
    required int userId
  }) {
    return repository.getCapturista(userId: userId);
  }
}