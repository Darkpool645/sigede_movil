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

      // Deserializar 'authorities' de String a lista de Map
      final authorities = json.decode(decodedToken['authorities'] as String) as List<dynamic>?;

      // Si la lista tiene datos, extraer el primer 'authority'
      if (authorities != null && authorities.isNotEmpty) {
        final role = authorities[0] as Map<String, dynamic>?;
        return role?['authority'] as String?;
      }
      return null;
    } catch (e) {
      return null; // Devuelve null si ocurre un error
    }
  }

  static String? getEmailFromToken(String token) {
    try {
      final decodedToken = decode(token);
      return decodedToken['sub'] as String?;
    } catch (e) {
      return null;
    }
  }

  static bool isExpired(String token) {
    try {
      final decodedToken = decode(token);
      final exp = decodedToken['exp'] as int?;
      if (exp == null) return true; // Si no hay exp, se asume expirado
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // Si hay un error, asume que el token está expirado
    }
  }
}
