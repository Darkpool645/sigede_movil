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
        // Aquí se espera una respuesta con un token y un email
        final responseData = response.data as Map<String, dynamic>;
        final token = responseData['token'] as String;
        final userEmail = responseData['email'] as String;

        // Guardar el token en el servicio de almacenamiento
        await TokenService.saveToken(token);

        // Decodificar el token para obtener información adicional (si es necesario)
        final role = JwtDecoder.getRoleFromToken(token) ?? 'user'; // Asignar un valor por defecto si el rol es null


        return {
          'success': true,
          'token': token,
          'role': role,
        };
      } else {
        // Si la respuesta no es 200, es un error
        return {
          'success': false,
          'message': 'Error en la autenticación. Código: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Manejo de errores en caso de que haya excepciones
      return {
        'success': false,
        'message': 'Error al realizar la petición: $e',
      };
    }
  }

  Future<void> logout() async {
    await TokenService.clearToken(); // Borrar token
  }
}
