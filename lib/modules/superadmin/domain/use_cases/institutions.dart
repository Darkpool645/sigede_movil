import 'package:sigede_movil/modules/superadmin/data/models/institutions_model.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/institutions_repository.dart';

class Institutions {
  final InstitutionsRepository repository;

  Institutions({required this.repository});

  Future<InstitutionsModel> call() async {
    return await repository.getAllInstitutions();
  }
}