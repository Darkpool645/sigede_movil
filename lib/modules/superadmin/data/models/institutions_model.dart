import 'package:sigede_movil/modules/superadmin/domain/entities/institutions_entity.dart';

class InstitutionsModel {
  final List<InstitutionsEntity> data;

  InstitutionsModel({required this.data});
  factory InstitutionsModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<InstitutionsEntity> institutionsList = list
        .map((item) => InstitutionsEntity.fromJson(item))
        .toList();

    return InstitutionsModel(data: institutionsList);
  }
}