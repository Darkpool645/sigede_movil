class Validators {
  String? validateEmail(String? value) {
  final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  if (value == null || value.isEmpty) {
    return 'Campo requerido';
  } else if (!emailRegExp.hasMatch(value)) {
    return 'Formato de correo incorrecto';
  } 
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo requerido';
  } else if (value.length < 8) {
    return 'Debe de escribir 8 caracteres como mínimo';
  }
  return null;
}

String? validatePhone(String? value) {
  final RegExp phoneRegExp = RegExp(
    r'^[\d]{8,}$',
  );
  if (value == null || value.isEmpty) {
    return 'Campo requerido';
  } else if (!phoneRegExp.hasMatch(value)){
    return 'Formato de teléfono incorrecto';
  }
  return null;
}
}