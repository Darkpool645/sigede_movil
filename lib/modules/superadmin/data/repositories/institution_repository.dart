import 'package:sigede_movil/modules/superadmin/data/datasources/institution_data_source.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/institution_entity.dart';

abstract class InstitutionRepository {
  Future<InstitutionResponseEntity> getInstitutionsByName(
      String name, int page, int size);
}

class InstitutionRepositoryImpl implements InstitutionRepository {
  final InstitutionDataSource institutionDataSource;

  InstitutionRepositoryImpl({required this.institutionDataSource});

  @override
  Future<InstitutionResponseEntity> getInstitutionsByName(
      String name, int page, int size) async {
    return await institutionDataSource.getInstitutionsByName(name, page, size);
  }
}
