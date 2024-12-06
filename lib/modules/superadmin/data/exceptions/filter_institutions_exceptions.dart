class FilterInstitutionsExceptions {
  final String meesage;
  FilterInstitutionsExceptions(this.meesage);
}

class BadRequestException extends FilterInstitutionsExceptions {
  BadRequestException() : super('body no válido.');
}

class UnauthorizedException extends FilterInstitutionsExceptions {
  UnauthorizedException() : super('Inautorizado');
}

class InstitutionsNotFoundException extends FilterInstitutionsExceptions {
  InstitutionsNotFoundException() : super('No encontrado');
}

class ServerException extends FilterInstitutionsExceptions {
  ServerException() : super('Error en el servidor.');
}
