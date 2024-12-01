import 'package:flutter/material.dart';

class ValidationPasswordScreen extends StatelessWidget {
  const ValidationPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Validar código de seguridad',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      )
    );
  }
}