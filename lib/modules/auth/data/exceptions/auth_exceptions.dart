// auth_exceptions.dart
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
class BadRequestException extends AuthException {
  BadRequestException() : super('Correo o contraseña incorrectos.');
}
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Correo o contraseña incorrectos.');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('Usuario no encontrado.');
}

class ServerException extends AuthException {
  ServerException() : super('Error en el servidor.');
}

class NetworkException extends AuthException {
  NetworkException() : super('Error de red.');
}
