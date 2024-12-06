class CredentialModel {
  final int credentialId;
  final String fullname;
  final String userPhoto;
  final DateTime expirationDate;

  CredentialModel({
    required this.credentialId,
    required this.fullname,
    required this.userPhoto,
    required this.expirationDate,
  });

  // Método para deserializar JSON
  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return CredentialModel(
      credentialId: json['credentialId'],
      fullname: json['fullname'],
      userPhoto: json['userPhoto'],
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }
}

class ApiResponse {
  final List<CredentialModel> credentials;

  ApiResponse({required this.credentials});

  // Método para deserializar JSON completo
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final content = json['data']['content'] as List<dynamic>;
    return ApiResponse(
      credentials: content.map((e) => CredentialModel.fromJson(e)).toList(),
    );
  }
}