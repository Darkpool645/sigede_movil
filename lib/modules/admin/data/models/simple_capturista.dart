class SimpleCapturista {
  final int userId;
  final String email;
  final String name;

  SimpleCapturista({
    required this.userId,
    required this.email,
    required this.name,
  });

  factory SimpleCapturista.fromJson(Map<String, dynamic> json) {
    return SimpleCapturista(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
    );
  }
}