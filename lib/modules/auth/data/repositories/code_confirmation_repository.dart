import 'package:sigede_movil/modules/auth/data/datasources/code_confirmation_data_source.dart';
import 'package:sigede_movil/modules/auth/data/models/code_confirmation_model.dart';
import 'package:sigede_movil/modules/auth/domain/entities/code_confirmation_entity.dart';

abstract class CodeConfirmationRepository {
  Future<CodeConfirmationEntity> codeConfirmation(CodeConfirmationModel model);
}

class CodeConfirmationRepositoryImpl implements CodeConfirmationRepository {
  final CodeConfirmationDataSource codeConfirmationDataSource;

  CodeConfirmationRepositoryImpl({required this.codeConfirmationDataSource});

  @override
  Future<CodeConfirmationEntity> codeConfirmation(CodeConfirmationModel model) async {
    return await codeConfirmationDataSource.codeConfirmation(model);
  }
}