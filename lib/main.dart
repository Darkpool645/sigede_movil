import 'package:flutter/material.dart';
import 'package:sigede_movil/features/authentication/public_navigator.dart';
import 'package:sigede_movil/app_navigator.dart';
import 'package:sigede_movil/utils/jwt_decoder.dart';
import 'package:sigede_movil/core/services/token_service.dart';
import 'package:sigede_movil/config/locator.dart';

void main() {
  setupServicesl();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGEDE Móvil',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<String?>(
        future: _determineStartRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final role = snapshot.data;
          if (role == null) {
            return const PublicNavigator(); 
          }

          return AppNavigator(userRole: role);
        },
      ),
    );
  }

  Future<String?> _determineStartRoute() async {
    final token = await TokenService.getToken();

    if (token != null && !JwtDecoder.isExpired(token)) {
      return JwtDecoder.getRoleFromToken(token);
    }

    return null;
  }
}
