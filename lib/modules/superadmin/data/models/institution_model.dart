import 'package:sigede_movil/modules/superadmin/domain/entities/institution_entity.dart';
import 'package:sigede_movil/modules/superadmin/domain/entities/institutions_entity.dart';

class InstitutionModel extends InstitutionsEntity {
  InstitutionModel({
    required super.id,
    required super.name,
    required super.emailContact,
    required super.logo,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'],
      name: json['name'],
      emailContact: json['email_contact'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'email_contact': super.emailContact,
      'logo': super.logo,
    };
  }
}

class PageModel extends PageEntity {
  PageModel({
    required super.size,
    required super.number,
    required super.totalElements,
    required super.totalPages,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      size: json['size'],
      number: json['number'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}

class InstitutionResponseModel extends InstitutionResponseEntity {
  InstitutionResponseModel({
    required super.error,
    required super.message,
    required super.content,
    required super.page,
  });

  factory InstitutionResponseModel.fromJson(Map<String, dynamic> json) {
    return InstitutionResponseModel(
      error: json['error'],
      message: json['message'],
      content: (json['data']['content'] as List)
          .map((e) => InstitutionModel.fromJson(e))
          .toList(),
      page: PageModel.fromJson(json['data']['page']),
    );
  }
}
