import 'package:flutter/material.dart';
import 'package:sigede_movil/features/superadmin/superadmin_navigator.dart';
import 'package:sigede_movil/features/admin/admin_navigator.dart';
import 'package:sigede_movil/features/capturist/capturist_navigator.dart';
import 'package:sigede_movil/features/authentication/public_navigator.dart';

class AppNavigator extends StatelessWidget {
  final String userRole;

  const AppNavigator({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case 'SUPERADMIN':
        return const SuperAdminNavigator();
      case 'ADMIN':
        return  const AdminNavigator();
      case 'CAPTURIST':
        return  const CapturistNavigator();
      default:
        return const PublicNavigator(); // Si el rol es inválido, vuelve al flujo público
    }
  }
}
