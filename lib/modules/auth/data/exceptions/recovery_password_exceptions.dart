class RecoveryPasswordExceptions implements Exception{
  final String message;
  RecoveryPasswordExceptions(this.message);
}

class InvalidEmailException extends RecoveryPasswordExceptions {
  InvalidEmailException() : super('Correo no válido.');
}

class UserNotFoundException extends RecoveryPasswordExceptions {
  UserNotFoundException() : super('Usuario no encontrado.');
}

class ServerException extends RecoveryPasswordExceptions {
  ServerException() : super('Error en el servidor.');
}

class NetworkException extends RecoveryPasswordExceptions {
  NetworkException() : super('Error de red.');
}

class BadRequestException extends RecoveryPasswordExceptions {
  BadRequestException() : super('Correo no válido.');
}