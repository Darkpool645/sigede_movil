import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sigede_movil/features/authentication/data/exceptions/recovery_password_exceptions.dart';
import 'package:sigede_movil/features/authentication/data/models/recovery_password_model.dart';
import 'package:sigede_movil/features/authentication/domain/use_cases/recovery_password.dart';
import 'package:sigede_movil/features/common/loading_circles.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isValidUserEmail = true;
  final GetIt getIt = GetIt.instance;

  Future<void> _recoveryPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String userEmail = _emailController.text.trim();
        final RecoveryPasswordModel model =
            RecoveryPasswordModel(userEmail: userEmail);

        final recoveryUseCase = getIt<RecoveryPassword>();

        final result = await recoveryUseCase.call(model);
        if (result.error == false) {
          MotionToast.success(
            description: const Text("Correo enviado con éxito."),
            position: MotionToastPosition.top,
          ).show(context);
          Navigator.pushNamed(context, '/validate-code', arguments: userEmail);
        } else {
          throw Exception('Error al enviar el correo');
        }
      } on InvalidEmailException {
        MotionToast.error(
          description: const Text('Correo no válido'),
          position: MotionToastPosition.top,
        ).show(context);
      } on UserNotFoundException {
        MotionToast.error(
          description: const Text('Usuario no encontrado'),
          position: MotionToastPosition.top,
        ).show(context);
      } on ServerException {
        MotionToast.error(
          description: const Text('Ocurrió un error. Inténtelo más tarde'),
          position: MotionToastPosition.top,
        ).show(context);
      } on BadRequestException {
        MotionToast.error(
          description: const Text('Correo no válido'),
          position: MotionToastPosition.top,
        ).show(context);
      } finally {
        setState(() {
          _isLoading = false;
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
      return ('Campo obligatorio');
    } else if (!emailRegExp.hasMatch(value)) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Formato de correo inválido';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Reestablecer contraseña',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Ingresa tu dirección de correo electrónico para recibir instrucciones para crear una nueva contraseña.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36.0),
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
                          color: _isValidUserEmail ? Colors.grey : Colors.red,
                        ),
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: _isValidUserEmail ? Colors.grey : Colors.red,
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
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _recoveryPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ), 
                    child: _isLoading
                      ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: LoadingCircles(),
                      )
                      : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
      ),
    );
  }
}
