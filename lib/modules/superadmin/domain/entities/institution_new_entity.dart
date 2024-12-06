class InstitutionNewEntity {
  final int? id;
  final String institutionName;
  final String institutionAddress;
  final String institutionEmail;
  final String institutionPhone;
  final String? logo;
  final int? data;

  InstitutionNewEntity({
    this.data, 
    this.id,
    required this.institutionName,
    required this.institutionAddress,
    required this.institutionEmail,
    required this.institutionPhone,
    this.logo,
  });
}
