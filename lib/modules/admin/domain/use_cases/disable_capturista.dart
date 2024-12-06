import 'package:sigede_movil/modules/admin/data/repositories/capturista_repository.dart';

class DisableCapturista {
  final CapturistaRepository repository;

  DisableCapturista({required this.repository}) ;

  Future<dynamic> call({
    required String email,
    required String status
  }) {
    return repository.disableCapturista(email: email, status: status);
  }
}