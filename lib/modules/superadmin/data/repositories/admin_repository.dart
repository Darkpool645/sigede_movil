import 'package:sigede_movil/modules/superadmin/data/datasources/admin_data_source.dart';
import 'package:sigede_movil/modules/superadmin/data/models/admin_model.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/admin_entity.dart';

abstract class AdminRepository {
  Future<AdminEntity> postAdmin(AdminModel model);
}

class AdminRepositoryImpl implements AdminRepository {
  final AdminDataSource adminDataSource;

  AdminRepositoryImpl({required this.adminDataSource});

  @override
  Future<AdminEntity> postAdmin(AdminModel model) async {
    return await adminDataSource.postAdmin(model);
  }
}