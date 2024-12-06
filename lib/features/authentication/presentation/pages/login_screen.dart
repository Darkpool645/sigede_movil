import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sigede_movil/core/services/token_service.dart';
import 'package:sigede_movil/app_navigator.dart';
import 'package:sigede_movil/features/authentication/data/exceptions/auth_exceptions.dart';
import 'package:sigede_movil/features/authentication/data/models/login_model.dart';
import 'package:sigede_movil/features/authentication/domain/entities/login_entity.dart';
import 'package:sigede_movil/features/authentication/domain/use_cases/login.dart';
import 'package:sigede_movil/features/common/loading_circles.dart';

class LoginScreen extends StatefulWidget {
  final LoginEntity? entity;
  const LoginScreen({
    super.key,
    this.entity
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isValidPassword = true;
  bool _isValidUserEmail = true;
  bool _isLoading = false;
  final GetIt getIt = GetIt.instance;
  final tokenService = GetIt.instance<TokenService>();
  
  Future<void> _loginSubmit() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      final LoginModel loginModel = LoginModel(
        email: email,
        password: password,
      );

      final loginUseCase = getIt<Login>();
      final result = await loginUseCase.call(loginModel);

      if (result.token != null) {
        // Guardar token, email e institutionId
        await TokenService.saveToken(result.token!);
        await TokenService.saveEmail(result.email);
        await TokenService.saveInstitutionId(result.institutionId); // Almacenar institutionId si está disponible

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppNavigator(userRole: result.role!),
          ),
        );
      } else {
        throw Exception("Error: Token no recibido");
      }
    } on InvalidCredentialsException {
      MotionToast.error(
        title: const Text("Error"),
        description: const Text('Credenciales inválidas'),
        position: MotionToastPosition.top,
      ).show(context);
    } on UserNotFoundException {
      MotionToast.error(
        title: const Text("Error"),
        description: const Text('Usuario no encontrado'),
        position: MotionToastPosition.top,
      ).show(context);
    } on NetworkException {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text('Hubo un problema al iniciar sesión. Inténtalo más tarde'),
        position: MotionToastPosition.top,
      ).show(context);
    } on AuthException catch (authError) {
      MotionToast.error(
        title: const Text('Error'),
        description: Text(authError.message),
        position: MotionToastPosition.top,
      ).show(context);
    } catch (error) {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text('Hubo un problema al iniciar sesión. Inténtalo más tarde'),
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
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    );

    if (value == null || value.isEmpty) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Campo obligatorio';
    } else if (!emailRegExp.hasMatch(value)) {
      setState(() {
        _isValidUserEmail = false;
      });
      return 'Formato de correo electrónico inválido';
    }
    setState(() {
      _isValidUserEmail = true;
    });
    return null;
  }

  String? validatePassword(String? value) {
    if(value == null || value.isEmpty) {
      setState(() {
        _isValidPassword = false;
      });
      return 'Campo obligatorio';
    } 
    setState(() {
      _isValidPassword = true;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      'https://i.ibb.co/sPtHpG9/Icono.png',
                      height: screenHeight * 0.2,
                      width: screenHeight * 0.3,
                    ),
                    const Text('S I G E D E'),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: validateEmail,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        obscureText: _isObscure,
                        validator: validatePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(
                              _isObscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginSubmit,
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
                TextButton(
                  onPressed: _isLoading
                    ? null
                    : () {
                      Navigator.pushNamed(context, '/recovery-password');
                    },
                  child: const Text(
                    'Olvide la contraseña',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black
                    )
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}