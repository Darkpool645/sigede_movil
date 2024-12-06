class ResetPasswordExceptions {
  final String message;
  ResetPasswordExceptions(this.message);
}

class BadRequestException extends ResetPasswordExceptions{
  BadRequestException() : super('Ocurrió un error al intentar cambiar la contraseña.');
}

class UserNotFoundException extends ResetPasswordExceptions {
  UserNotFoundException() : super('Usuario no encontrado.');
}
class ServerException extends ResetPasswordExceptions {
  ServerException() : super('Error en el servidor.');
}

class NetworkException extends ResetPasswordExceptions {
  NetworkException() : super('Error de red.');
}