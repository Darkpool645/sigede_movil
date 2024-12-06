import 'package:sigede_movil/modules/superadmin/data/datasources/institution_post_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/models/institution_new_model.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/institutions_entity.dart';

abstract class InstitutionNewRepository {
  Future<InstitutionsEntity> postInstitution(InstitutionNewModel model);
}

class InstitutionNewRepositoryImpl implements InstitutionNewRepository {
  final InstitutionPostDataSource institutionPostDataSource;

  InstitutionNewRepositoryImpl({required this.institutionPostDataSource});

  @override
  Future<InstitutionsEntity> postInstitution(InstitutionNewModel model) async {
    return await institutionPostDataSource.postInstitution(model);
  }
}