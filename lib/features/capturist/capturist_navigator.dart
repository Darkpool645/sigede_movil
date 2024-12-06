import 'package:flutter/material.dart';
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
    const CredentialsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capturista')),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Credenciales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
