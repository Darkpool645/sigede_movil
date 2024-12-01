import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic> decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token no válido');
    }

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }

  static String? getRoleFromToken(String token) {
    try {
      final decodedToken = decode(token);
      final roles = decodedToken['roles'] as List<dynamic>;
      return roles.isNotEmpty ? roles[0]['authority'] : null;
    } catch (e) {
      return null; // Devuelve null si ocurre un error
    }
  }

  static bool isExpired(String token) {
    try {
      final decodedToken = decode(token);
      final exp = decodedToken['exp'] as int;
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // Si hay un error, asume que el token está expirado
    }
  }
}
