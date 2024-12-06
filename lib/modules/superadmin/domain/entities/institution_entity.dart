import 'package:sigede_movil/modules/superadmin/domain/entities/institutions_entity.dart';

class PageEntity {
  final int size;
  final int number;
  final int totalElements;
  final int totalPages;

  PageEntity({
    required this.size,
    required this.number,
    required this.totalElements,
    required this.totalPages,
  });
}

class InstitutionResponseEntity {
  final bool error;
  final String message;
  final List<InstitutionsEntity> content;
  final PageEntity page;

  InstitutionResponseEntity({
    required this.error,
    required this.message,
    required this.content,
    required this.page,
  });
}
