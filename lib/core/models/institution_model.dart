class Institution {
  final String name;
  final String address;
  final String logo;
  final String emailContact;
  final String phoneContact;
  final String statusName;

  Institution({
    required this.name,
    required this.address,
    required this.logo,
    required this.emailContact,
    required this.phoneContact,
    required this.statusName,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      name: json['name'],
      address: json['address'],
      logo: json['logo'],
      emailContact: json['emailContact'],
      phoneContact: json['phoneContact'],
      statusName: json['fkStatus']['statusName'],
    );
  }
}