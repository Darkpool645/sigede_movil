import 'package:sigede_movil/modules/superadmin/data/models/institution_new_model.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/institution_new_repository.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/institutions_entity.dart';

class PostInstitution {
  final InstitutionNewRepository repository;

  PostInstitution({required this.repository});

  Future<InstitutionsEntity> call(InstitutionNewModel model) async {
    return await repository.postInstitution(model);
  }
}