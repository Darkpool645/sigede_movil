import 'package:flutter/material.dart';
import 'package:sigede_movil/modules/capturista/presentation/pages/credentials_management.dart';
import 'package:sigede_movil/modules/capturista/presentation/pages/register_credential.dart';
import 'credentials_screen.dart';
import '../profile/profile_screen.dart';

class CapturistNavigator extends StatefulWidget {
  const CapturistNavigator({super.key});

  @override
  _CapturistNavigatorState createState() => _CapturistNavigatorState();
}

class _CapturistNavigatorState extends State<CapturistNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CredentialsManagement(),
    const RegisterCredential(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Color de la sombra
              spreadRadius: 0, // Cuánto se extiende la sombra
              blurRadius: 10, // Qué tan difusa es la sombra
              offset: const Offset(0,
                  -5), // Desplazamiento de la sombra (en este caso hacia arriba)
            ),
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt),
              label: 'Registrar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
          backgroundColor: const Color(0xFF917D62),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          showSelectedLabels: true,
        ),
      ),
    );
  }
}
