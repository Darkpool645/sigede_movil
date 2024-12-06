class SimpleCapturista {
  final int userAccountId;
  final String status;
  final String name;

  SimpleCapturista({
    required this.userAccountId,
    required this.status,
    required this.name,
  });

  factory SimpleCapturista.fromJson(Map<String, dynamic> json) {
    return SimpleCapturista(
      userAccountId: json['userAccountId'],
      status: json['status'],
      name: json['name'],
    );
  }
}