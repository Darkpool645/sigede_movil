import 'package:sigede_movil/features/authentication/data/models/login_model.dart';
import 'package:sigede_movil/features/authentication/data/repositories/login_repository.dart';
import 'package:sigede_movil/features/authentication/domain/entities/login_entity.dart';

class Login {
  final LoginRepository repository;

  Login({
    required this.repository
  });

  Future<LoginEntity> call(LoginModel model) async {
    return await repository.login(model);
  }
}