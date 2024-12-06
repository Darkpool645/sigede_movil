import 'package:sigede_movil/modules/superadmin/domain/entities/institution_new_entity.dart';

class InstitutionNewModel extends InstitutionNewEntity{
  InstitutionNewModel({
    super.id,
    required super.institutionName,
    required super.institutionAddress,
    required super.institutionEmail,
    required super.institutionPhone,
    super.logo,
    super.data,
  });

  factory InstitutionNewModel.fromJson(Map<String, dynamic> json) {
    return InstitutionNewModel(
      
      id: json['id'],
      institutionName: json['name'],
      institutionAddress: json['address'],
      institutionEmail: json['emailContact'],
      institutionPhone: json['phone'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {      
      'institutionName': institutionName,
      'institutionAddress': institutionAddress,
      'institutionEmail': institutionEmail,
      'institutionPhone': institutionPhone,
      'logo': logo,
    };
  }
}

