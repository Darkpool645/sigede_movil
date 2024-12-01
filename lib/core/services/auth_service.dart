import '../../config/dio_client.dart';
import '../models/api_response.dart';
import '../services/token_service.dart';

class AuthService {
  final DioClient _client;

  AuthService() : _client = DioClient();

  Future<ApiResponse<String>> login(String email, String password) async {
    try {
      final response = await _client.dio.post(
        '/api/auth/login',
        data: {'username': email, 'password': password},
      );

      final apiResponse = ApiResponse<String>.fromJson(
        response.data,
        (data) => data as String,
      );

      if (!apiResponse.error && apiResponse.data != null) {
        await TokenService.saveToken(apiResponse.data!); // Guardar token
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<String>(
        data: null,
        error: true,
        statusCode: 500,
        message: 'Error al iniciar sesión: $e',
      );
    }
  }

  Future<ApiResponse<String>> recoverPassword(String email) async {
    try{
      final response = await _client.dio.post(
        '/api/auth/recovery-password',
        data: {'username': email},
      );

      final apiResponse = ApiResponse<String>.fromJson(
        response.data,
        (data) => data as String,
      );

      return apiResponse;
    } catch (e) {
      return ApiResponse<String>( 
        data: null,
        error: true,
        statusCode: 500,
        message: 'Error al recuperar la contraseña: $e',
      );
    }
  }

  Future<void> logout() async {
    await TokenService.clearToken(); // Borrar token
  }
}
