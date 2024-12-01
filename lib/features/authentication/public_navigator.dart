import 'package:flutter/material.dart';
import 'package:sigede_movil/features/authentication/login_screen.dart';
import 'package:sigede_movil/features/authentication/recovery_password_screen.dart';
import 'package:sigede_movil/features/authentication/validation_passowrd_screen.dart';
import 'package:sigede_movil/features/authentication/update_password_screen.dart';

class PublicNavigator extends StatelessWidget {
  const PublicNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/recovery-password':
            page = const RecoveryPasswordScreen();
            break;
          case '/change-password':
            page = const UpdatePasswordScreen();
            break;
          case '/validate-code':
            page = const ValidationPasswordScreen();
            break;
          case '/login':
          default:
            page = const LoginScreen();
        }

        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}
