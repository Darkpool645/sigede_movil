import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sigede_movil/modules/auth/data/exceptions/code_exceptions.dart';
import 'package:sigede_movil/modules/auth/data/models/code_confirmation_model.dart';
import 'package:sigede_movil/modules/auth/domain/use_cases/code_confirmation.dart';
import 'package:sigede_movil/modules/auth/presentation/pages/reset_password_screen.dart';
import 'package:sigede_movil/widgets.dart/error_dialog.dart';
import 'package:sigede_movil/widgets.dart/loading_widget.dart';
import 'package:sigede_movil/widgets.dart/success_dialog.dart';

class CodeConfirmationScreen extends StatefulWidget {
  final int? userId;
  const CodeConfirmationScreen({super.key, this.userId});

  @override
  State<CodeConfirmationScreen> createState() => _CodeConfirmationState();
}

class _CodeConfirmationState extends State<CodeConfirmationScreen> {
  late int? userId;

  @override
  void initState() {
    super.initState();
    // Asignar el userId recibido
    userId = widget.userId;
  }

  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isloading = false;

  String? _code;
  String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese su código';
    }

    final int? code = int.tryParse(value);

    if (code == null || code <= 0) {
      return 'Por favor, ingrese un código válido';
    }

    return null;
  }

  Future<void> _checkClipboardForCode() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      String pastedCode = clipboardData.text!;
      if (pastedCode.length == 6 && _isNumeric(pastedCode)) {
        setState(() {
          _codeController.text = pastedCode;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Código pegado automáticamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No hay un código válido en el portapapeles")),
        );
      }
    }
  }

  bool _isNumeric(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  final GetIt getIt = GetIt.instance;
  Future<void> _codeConfirmationDio() async {
    print(userId);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      try {
        final String verificationCode = _codeController.text.trim();

        final CodeConfirmationModel model = CodeConfirmationModel(
          code: verificationCode,
          userId: userId,
        );

        final codeUseCase = getIt<CodeConfirmation>();

        final result = await codeUseCase.call(model);
        if (result.error == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Código verificado correctamente")),
          );
          await showSuccessDialog(
              context: context, message: "Código verificado correctamente");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(userId: result.data),
            ),
          );
        } else {
          throw Exception("Error: codigo");
        }
      } on BadRequestException {
        showErrorDialog(context: context, message: "Código no válido");
      } on UserNotFoundException {
        showErrorDialog(context: context, message: "Usuario no encontrado");
      } on CodeVerificationException {
        showErrorDialog(
            context: context, message: "Error en la verificación del código");
      } on InvalidCodeException {
        showErrorDialog(context: context, message: "Código inválido");
      } on CodeExpiredException {
        showErrorDialog(context: context, message: "Código expirado");
      } on ServerException {
        showErrorDialog(context: context, message: "Error en el servidor");
      } on NetworkException {
        showErrorDialog(context: context, message: "Error de red");
      } on UnexpectedException {
        showErrorDialog(context: context, message: "Error inesperado");
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
                  'Verificar código',
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
                  'Para restablecer tu contraseña, por favor ingresa el código de verificación que hemos enviado a tu correo electrónico',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(color: Colors.grey)),
                ),
                const SizedBox(
                  height: 36.0,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        PinCodeTextField(
                            readOnly: _isloading,
                            appContext: context,
                            length: 6,
                            controller: _codeController,
                            onChanged: (value) {
                              setState(() {
                                _code = value;
                              });
                            },
                            onTap: () async {
                              await _checkClipboardForCode();
                            },
                            validator: validateCode,
                            textStyle: const TextStyle(color: Colors.black),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeColor: Colors.black,
                              selectedColor: Colors.red,
                              inactiveColor: Colors.red,
                            ),
                            keyboardType: TextInputType.number,
                            enablePinAutofill: true),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Column()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isloading ? null : _codeConfirmationDio,
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
