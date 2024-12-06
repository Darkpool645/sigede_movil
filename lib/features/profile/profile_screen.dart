import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  bool isEditing = false; // Controla si estamos en modo edición

  // Controladores para los campos de texto
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Hace que el contenido sea scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.blue,
                    ),
                     SizedBox(height: 10),
                     Text(
                      'Universidad Tecnológica\nEmiliano Zapata',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Campo no editable: Nombre
              TextFormField(
                initialValue: 'Juan Pérez', // Reemplaza con el valor dinámico
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                enabled: false, // No editable
              ),
              const SizedBox(height: 20),

              // Campo no editable: Correo
              TextFormField(
                initialValue: 'juan.perez@ejemplo.com', // Reemplaza con el valor dinámico
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                enabled: false, // No editable
              ),
              const SizedBox(height: 30),

              // Modo edición: Mostrar los campos de contraseñas si `isEditing` es true
              if (isEditing) ...[
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña actual',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nueva contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar nueva contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
              ],

              // Botón "Editar" o "Guardar"
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      // Aquí manejar lógica para guardar contraseñas
                    }
                    isEditing = !isEditing; // Alternar entre edición y vista
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.green : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  isEditing ? 'Guardar' : 'Editar',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Botón "Cerrar sesión"
              ElevatedButton(
                onPressed: () async {
                  await _authService.logout();
                  // Aquí iría la lógica para cerrar sesión
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
