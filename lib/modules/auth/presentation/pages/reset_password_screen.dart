import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sigede_movil/modules/auth/data/exceptions/reset_password_exceptions.dart';
import 'package:sigede_movil/modules/auth/data/models/reset_password_model.dart';
import 'package:sigede_movil/modules/auth/domain/use_cases/reset_password.dart';
import 'package:sigede_movil/widgets.dart/loading_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final int? userId;
  const ResetPasswordScreen({super.key, this.userId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late int? userId;
  @override
  void initState() {
    super.initState();
    // Asignar el userId recibido
    userId = widget.userId;
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObscure = true;
  bool _isObcureCP = true;
  bool _isloading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValidPassword = true;
  bool _isValidConfirmPassword = true;
  // Función para validar la confirmación de la contraseña
  String? confirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      setState(() {
        _isValidConfirmPassword = false;
      });
      return 'Por favor, confirme su contraseña';
    } else if (_passwordController.text != confirmPassword) {
      setState(() {
        _isValidConfirmPassword = false;
      });
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _isValidPassword = false;
      });
      return 'Ingrese una contraseña';
    } else if (value.length < 8) {
      setState(() {
        _isValidPassword = false;
      });
      return 'La contraseña debe tener al menos 8 caracteres';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      setState(() {
        _isValidPassword = false;
      });
      return 'La contraseña debe contener al menos una letra mayúscula';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      setState(() {
        _isValidPassword = false;
      });
      return 'La contraseña debe contener al menos una letra minúscula';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      setState(() {
        _isValidPassword = false;
      });
      return 'La contraseña debe contener al menos un número';
    } else if (value.contains(" ")) {
      setState(() {
        _isValidPassword = false;
      });
      return 'La contraseña no debe contener espacios';
    } else if (!RegExp(r'^[a-zA-Z0-9\s]*$').hasMatch(value)) {
      setState(() {
        _isValidPassword = false;
      });
      return 'La contraseña no debe contener caracteres especiales';
    }
    setState(() {
      _isValidPassword = true;
    });
    return null;
  }

  void handlePasswordResetResult(BuildContext context, bool error) {
    if (!error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                SizedBox(width: 8),
              ],
            ),
            content: const Text(
              "Tu contraseña ha sido restablecida exitosamente.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Center(
                child: SizedBox(
                  width: 100,
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black, // Botón verde
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showErrorDialog(
        context: context,
        message: "Ocurrió un error al intentar cambiar la contraseña.",
      );
    }
  }

  void showErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  final GetIt getIt = GetIt.instance;
  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      try {
        final String password = _passwordController.text.trim();

        final ResetPasswordModel model = ResetPasswordModel(
          newPassword: password,
          userId: userId,
        );

        final resetPasswordUseCase = getIt<ResetPassword>();

        final result = await resetPasswordUseCase.call(model);
        handlePasswordResetResult(context, result.error!);
      } on BadRequestException {
        showErrorDialog(
            context: context,
            message: "Ocurrió un error al intentar cambiar la contraseña.");
      } on UserNotFoundException {
        showErrorDialog(context: context, message: "Usuario no encontrado.");
      } on ServerException {
        showErrorDialog(context: context, message: "Error en el servidor.");
      } on NetworkException {
        showErrorDialog(context: context, message: "Error de red.");
      } catch (e) {
        showErrorDialog(
            context: context, message: "Error inesperado: ${e.toString()}");
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Restablecer contraseña',
                  style: TextStyle(
                    fontFamily: 'RubikOne',
                    fontSize: 39,
                    height: 1.2,
                  ),
                  textAlign:
                      TextAlign.center, // Asegura que el texto esté centrado
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Tu nueva contraseña debe ser diferente a contraseñas anteriores',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 36.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: _isloading,
                        obscureText: _isObscure,
                        validator: validatePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            color: _isValidPassword
                                ? Colors.grey // Si la validación es exitosa
                                : Colors.red, // Si la validación falla
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        readOnly: _isloading,
                        obscureText: _isObscure,
                        validator: confirmPassword,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar contraseña',
                          labelStyle: TextStyle(
                            color: _isValidConfirmPassword
                                ? Colors.grey // Si la validación es exitosa
                                : Colors.red, // Si la validación falla
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              color: _isValidConfirmPassword
                                  ? Colors.grey // Si la validación es exitosa
                                  : Colors.red, // Si la validación falla
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: Column()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isloading ? null : _changePassword,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: _isloading
                          ? const LoadingWidget() // Mostrar loading si está cargando
                          : Text(
                              'Restablecer',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
