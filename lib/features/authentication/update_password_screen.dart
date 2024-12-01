import 'package:flutter/material.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Solicitar cambio de contraseña',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      )
    );
  }
}