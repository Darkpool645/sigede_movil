import 'package:sigede_movil/modules/superadmin/data/datasources/institutions_all_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/models/institutions_model.dart';

abstract class InstitutionsRepository {
  Future<InstitutionsModel> getAllInstitutions();
}

class InstitutionsRepositoryImpl implements InstitutionsRepository{
  final InstitutionsAllDataSource institutionsAllDataSource;

  InstitutionsRepositoryImpl({required this.institutionsAllDataSource});

  @override
  Future<InstitutionsModel> getAllInstitutions()async{
    return await institutionsAllDataSource.getAllInstitutions();
  }
}