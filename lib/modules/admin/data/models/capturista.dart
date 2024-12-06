class Capturista {
  final int userAccountId;
  final String email;
  final String name;
  final String status;

  Capturista({
    required this.userAccountId,
    required this.email,
    required this.name,
    required this.status,
  });

  factory Capturista.fromJson(Map<String, dynamic> json) {
    final user=json['data'];
    return Capturista(
      userAccountId: user['userAccountId'],
      email: user['email'],
      name: user['name'],
      status: user['status'],
    );
  }
}