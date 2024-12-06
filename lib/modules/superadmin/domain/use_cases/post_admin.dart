import 'package:sigede_movil/modules/superadmin/data/models/admin_model.dart';
import 'package:sigede_movil/modules/superadmin/data/repositories/admin_repository.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/admin_entity.dart';

class PostAdmin {
  final AdminRepository repository;

  PostAdmin({required this.repository});

  Future<AdminEntity> call(AdminModel model) async {
    return await repository.postAdmin(model);
  }
}