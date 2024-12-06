import 'package:flutter/material.dart';
import 'package:sigede_movil/modules/admin/presentation/screens/management_capturist.dart';
import 'credentials_screen.dart';
import '../profile/profile_screen.dart';

class AdminNavigator extends StatefulWidget {
  const AdminNavigator({super.key});

  @override
  _AdminNavigatorState createState() => _AdminNavigatorState();
}

class _AdminNavigatorState extends State<AdminNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ManagementCapturist(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
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
