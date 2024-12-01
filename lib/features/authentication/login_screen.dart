import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:sigede_movil/app_navigator.dart';
import 'package:sigede_movil/core/services/auth_service.dart';
import 'package:sigede_movil/utils/jwt_decoder.dart';
import 'package:sigede_movil/features/common/loading_circles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isObscure = true;
  bool _isLoading = false;

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
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await _authService.login(email, password);

      if (!response.error && response.data != null) {
        final token = response.data!;
        final role = JwtDecoder.getRoleFromToken(token).toString();

        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppNavigator(userRole: role),
          ),
        );
      } else {
        // Verificar statusCode para mensajes personalizados
        if (response.statusCode == 401) {
          // Credenciales incorrectas
          MotionToast.error(
            title: const Text("Error de autenticación"),
            description:
                const Text("Credenciales incorrectas, inténtalo de nuevo."),
            position: MotionToastPosition.top,
          ).show(context);
        } else {
          // Otros errores
          MotionToast.error(
            title: const Text("Error"),
            description:
                Text(response.message),
            position: MotionToastPosition.top,
          ).show(context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
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
                        fontSize: 36,
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
                          filled: true,
                          fillColor: Color.fromARGB(255, 199, 197, 197),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: _isObscure,
                        validator: validatePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 199, 197, 197),
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
                    onPressed: _isLoading ? null : _handleLogin,
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
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
