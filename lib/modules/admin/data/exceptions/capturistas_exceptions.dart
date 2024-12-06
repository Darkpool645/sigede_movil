class CapturistaExceptions {
  final String message;
  CapturistaExceptions(this.message);
}

class UnauthorizedException extends CapturistaExceptions {
  UnauthorizedException()
      : super('No tienes autorización para realizar esta acción.');
}

class NotFoundException extends CapturistaExceptions {
  NotFoundException()
      : super('No se encontró el recurso solicitado.');
}

class BadRequestException extends CapturistaExceptions {
  BadRequestException()
      : super('Los datos proporcionados son inválidos.');
}

class ServerException extends CapturistaExceptions {
  ServerException()
      : super('Ocurrió un error en el servidor.');
}

class NetworkException extends CapturistaExceptions {
  NetworkException()
      : super('Error de red, verifica tu conexión.');
}