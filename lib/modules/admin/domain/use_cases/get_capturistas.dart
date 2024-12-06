import 'package:sigede_movil/modules/admin/data/models/simple_capturista.dart';
import 'package:sigede_movil/modules/admin/data/repositories/capturista_repository.dart';

class GetCapturistas {
  final CapturistaRepository repository;

  GetCapturistas({required this.repository}) ;

  Future<List<SimpleCapturista>> call({
    required String role,
    required int institutionId,
  }) {
    return repository.getAllCapturistas(
      role: role,
      institutionId: institutionId,
    );
  }
}