import 'package:flutter/material.dart';
import 'institutions_screen.dart';
import 'create_institution_screen.dart';
import '../profile/profile_screen.dart';

class SuperAdminNavigator extends StatefulWidget {
  const SuperAdminNavigator({super.key});

  @override
  _SuperAdminNavigatorState createState() => _SuperAdminNavigatorState();
}

class _SuperAdminNavigatorState extends State<SuperAdminNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const InstitutionsScreen(),
    const CreateInstitutionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF917D62), 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.black, 
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Instituciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business),
            label: 'Registrar',
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
