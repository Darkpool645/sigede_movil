class InstitutionsAllExceptions {
  final String message;
  InstitutionsAllExceptions(this.message);
}

class BadRequestException extends InstitutionsAllExceptions {
  BadRequestException() : super('body no válido.');
}

class UnauthorizedException extends InstitutionsAllExceptions{
  UnauthorizedException(): super('Inautorizado');
}

class InstitutionsNotFoundException extends InstitutionsAllExceptions{
  InstitutionsNotFoundException():super('No encontrado');
}

class ServerException extends InstitutionsAllExceptions {
  ServerException() : super('Error en el servidor.');
}