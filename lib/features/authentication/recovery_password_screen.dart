import 'package:flutter/material.dart';
import 'package:sigede_movil/core/services/auth_service.dart';
import 'package:sigede_movil/core/models/api_response.dart';
import 'package:sigede_movil/features/common/loading_circles.dart';
import 'package:motion_toast/motion_toast.dart'; // Asegúrate de tener esta dependencia en tu pubspec.yaml

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreen();
}

class _RecoveryPasswordScreen extends State<RecoveryPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isValidUserEmail = true;

  String? validateEmail(String? value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if (value == null || value.isEmpty) {
      _isValidUserEmail = false;
      return 'Campo requerido';
    } else if (!emailRegExp.hasMatch(value)) {
      _isValidUserEmail = false;
      return 'Formato de correo incorrecto';
    }
    _isValidUserEmail = true;
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text;
      final ApiResponse<String> response =
          await _authService.recoverPassword(email);
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        MotionToast.success(
          description: const Text("Correo enviado con éxito."),
          position: MotionToastPosition.top,
        ).show(context);
      } else if (response.statusCode == 400) {
        MotionToast.error(
          description: const Text("No se pudo enviar el correo."),
          position: MotionToastPosition.top,
        ).show(context);
      } else if (response.statusCode == 404) {
        MotionToast.error(
          description: const Text("Usuario no encontrado."),
          position: MotionToastPosition.top,
        ).show(context);
      } else if (response.statusCode == 500) {
        MotionToast.error(
          description: const Text("Error del servidor."),
          position: MotionToastPosition.top,
        ).show(context);
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
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text(
                'Para restablecer tu contraseña, por favor ingresa tu dirección de correo electrónico a continuación. Recibirás un correo con instrucciones para crear una nueva contraseña.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 36.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: _isLoading,
                      validator: validateEmail,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        labelStyle: TextStyle(
                          color: _isValidUserEmail
                              ? Colors.grey // Si la validación es exitosa
                              : Colors.red, // Si la validación falla
                        ),
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: _isValidUserEmail
                              ? Colors.grey // Si la validación es exitosa
                              : Colors.red,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Expanded(child: Column()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRequest,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: _isLoading
                        ? const LoadingCircles() // Mostrar loading si está cargando
                        : const Text(
                            'Enviar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
