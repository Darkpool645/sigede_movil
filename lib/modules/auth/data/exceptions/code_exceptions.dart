class CodeExceptions {
  final String message;
  CodeExceptions(this.message);
}

class BadRequestException extends CodeExceptions {
  BadRequestException() : super('Código no válido.');
}
class UserNotFoundException extends CodeExceptions {
  UserNotFoundException() : super('Usuario no encontrado.');
}
//manejo de errorres para una verificacion de codigo
class CodeVerificationException extends CodeExceptions {
  CodeVerificationException() : super('Error en la verificación del código.');
}
class ServerException extends CodeExceptions {
  ServerException() : super('Error en el servidor.');
}
class NetworkException extends CodeExceptions {
  NetworkException() : super('Error de red.');
}
class UnexpectedException extends CodeExceptions {
  UnexpectedException() : super('Error inesperado.');
}
class InvalidCodeException extends CodeExceptions {
  InvalidCodeException() : super('Código inválido.');
}
class CodeExpiredException extends CodeExceptions {
  CodeExpiredException() : super('Código expirado.');
}
