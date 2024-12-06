import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sigede_movil/modules/auth/data/exceptions/recovery_password_exceptions.dart';
import 'package:sigede_movil/modules/auth/data/models/recovery_password_model.dart';
import 'package:sigede_movil/modules/auth/domain/use_cases/recovery_password.dart';
import 'package:sigede_movil/modules/auth/presentation/pages/code_confirmation_screen.dart';
import 'package:sigede_movil/widgets.dart/error_dialog.dart';
import 'package:sigede_movil/widgets.dart/loading_widget.dart';
import 'package:sigede_movil/widgets.dart/success_dialog.dart';

class Recoverpasswordscreen extends StatefulWidget {
  const Recoverpasswordscreen({super.key});

  @override
  State<Recoverpasswordscreen> createState() => _RecoverpasswordscreenState();
}

class _RecoverpasswordscreenState extends State<Recoverpasswordscreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  bool _isValidUserEmail = true;
  final GetIt getIt = GetIt.instance;

  Future<void> _recoveryPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      try {
        final String userEmail = _emailController.text.trim();
        final RecoveryPasswordModel model = RecoveryPasswordModel(
          userEmail: userEmail,
        );

        final recoveryUseCase = getIt<RecoveryPassword>();

        final result = await recoveryUseCase.call(model);
        print(result.data);
        if (result.error == false) {
          showSuccessDialog(
              context: context,
              message:
                  "Se ha enviado un correo con las instrucciones para restablecer tu contraseña");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CodeConfirmationScreen(userId: result.data),
            ),
          );
        } else {
          throw Exception('Error al enviar el correo');
        }
      } on InvalidEmailException {
        showErrorDialog(context: context, message: 'Correo no válido.');
      } on UserNotFoundException {
        showErrorDialog(context: context, message: 'Usuario no encontrado.');
      } on ServerException {
        showErrorDialog(context: context, message: 'Error en el servidor.');
      } on NetworkException {
        showErrorDialog(context: context, message: 'Error de red.');
      } on BadRequestException {
        showErrorDialog(context: context, message: 'Correo no válido.');
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    }
  }

  String? validateEmail(String? value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (value == null || value.isEmpty) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Por favor, ingrese su correo electrónico';
    } else if (!emailRegExp.hasMatch(value)) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Por favor, ingrese un correo electrónico válido';
    }
    setState(() {
      _isValidUserEmail = true;
    });
    return null;
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
                  'Para restablecer tu contraseña, por favor ingresa tu dirección de correo electrónico a continuación. Recibirás un correo con instrucciones para crear una nueva contraseña.',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 36.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        readOnly: _isloading,
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
                      onPressed: _isloading ? null : _recoveryPassword,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: _isloading
                          ? const LoadingWidget() // Mostrar loading si está cargando
                          : Text(
                              'Enviar',
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
/*
class OldViewRecovery extends StatelessWidget {
  const OldViewRecovery({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
  }) : _formKey = formKey, _emailController = emailController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recuperacion de contraseña',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF47649D),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFE4E4E4),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: const BoxConstraints(
                maxWidth: 600, 
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      "Recupera tu cuenta",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Favor de ingresar tu correo electrónico para buscar tu cuenta.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Ingresa tu correo electrónico",
                        label: const Text("Correo electrónico"),
                        filled: true, // Activa el fondo
                        fillColor: Colors.white, // color de fondo
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // Estilos cuando no está seleccionado
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print("AQUI VA LA LOGICA DEL ENVIO DE CORREOS");
                            Navigator.pushNamed(context, '/codeConfirmation');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF27AE60),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Enviar correo",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/