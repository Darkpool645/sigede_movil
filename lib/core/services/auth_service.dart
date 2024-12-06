import '../../config/dio_client.dart';
import '../services/token_service.dart';
import 'package:sigede_movil/utils/jwt_decoder.dart';

class AuthService {
  final DioClient _client;

  AuthService() : _client = DioClient();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final token = responseData['token'] as String;
        final userEmail = responseData['email'] as String;

        final institutionId = responseData.containsKey('institutionId')
            ? responseData['institutionId']
            : null;

        await TokenService.saveToken(token);
        await TokenService.saveEmail(userEmail);

        if (institutionId != null) {
          await TokenService.saveInstitutionId(institutionId);
        }

        // Decodificar el token para obtener información adicional
        final role = JwtDecoder.getRoleFromToken(token);

        return {
          'success': true,
          'token': token,
          'role': role,
        };
      } else {
        return {
          'success': false,
          'message':
              'Error en la autenticación. Código: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al realizar la petición: $e',
      };
    }
  }

  Future<void> logout() async {
    await TokenService.clearToken(); // Borrar token
    await TokenService.clearInstitutionId();
    await TokenService.clearUserEmail();
  }
}
