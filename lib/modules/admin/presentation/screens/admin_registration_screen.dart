import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminRegistrationScreen extends StatefulWidget {
  const AdminRegistrationScreen({super.key});

  @override
  State<AdminRegistrationScreen> createState() => _AdminRegistrationScreenState();
}

class _AdminRegistrationScreenState extends State<AdminRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  
  File? _image; // Aquí se almacena la imagen seleccionada

  // Función para seleccionar una imagen
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.badge,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  "SIDEGE",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
                Text(
                  "Super admin",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF47649D),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Registro de administrador',
                    style:
                      TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //input para imagen
                  GestureDetector(
                  onTap: _pickImage, // Acción al tocar el placeholder
                  child: _image == null
                  ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Subir Imagen',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Image.file(
                      _image!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),       
                  const SizedBox(
                    height: 35.0,
                  ),             
                  const Text(
                    'Datos de la Empresa/Organización',
                    style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Nombre de empresa/organización'),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Dirección de la empresa/organización')
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  const Text(
                    'Datos del administrador',
                    style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Nombre completo del administrador'),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Correo electrónico')),
                    keyboardType: TextInputType.emailAddress
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Contraseña'),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Número de teléfono')),
                    keyboardType: TextInputType.number
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                            // Valida y guarda el formulario cuando se presiona "Aceptar"
                          if (_formKey.currentState!.validate()) {
                              // Procesar los datos
                            print('Formulario válido');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                            Colors.green, // Botón de cancelar en rojo                        ),
                        ),
                        child: const Text(
                          'Aceptar',
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Colors.white)
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Aquí puedes definir lo que ocurre al presionar "Cancelar"
                          // En este caso, simplemente limpiamos el formulario
                          _formKey.currentState!.reset();
                          print('Formulario reseteado');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                            Colors.red.shade400, // Botón de cancelar en rojo                        ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      )
                    ],
                  ),                  
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
