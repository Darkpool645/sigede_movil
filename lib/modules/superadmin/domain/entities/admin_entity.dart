class AdminEntity {
  final String? name;
  final String? email;
  final int? fkInstitution;
  final int? status;
  AdminEntity({this.status, this.name, this.email,this.fkInstitution});

  factory AdminEntity.fromJson(Map<String, dynamic> json) {
    return AdminEntity(
      status: json['status'],
    );
  }
}