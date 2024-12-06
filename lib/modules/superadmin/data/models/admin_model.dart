import 'package:sigede_movil/modules/superadmin/domain/entities/admin_entity.dart';

class AdminModel extends AdminEntity {
  AdminModel({ required super.name,required super.email,super.fkInstitution});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      name: json['name'],
      email: json['email'],
      fkInstitution: json['institutionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'fkInstitution': fkInstitution,
    };
  }
}
