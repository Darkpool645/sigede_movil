import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:sigede_movil/core/services/cloudinary_service.dart';

class CreateAdminScreen extends StatefulWidget {
  final String name;
  final String address;
  final String email;
  final String phone;
  final Uint8List? selectedImageBytes;

  const CreateAdminScreen({
    Key? key,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.selectedImageBytes,
  }) : super(key: key);

  @override
  _CreateAdminScreenState createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _adminEmailController = TextEditingController();
  String? _imageUrl;
  String? _imageError;

  Future<void> _uploadImage() async {
    if (widget.selectedImageBytes == null) {
      setState(() {
        _imageError = 'Debe seleccionar una imagen antes de subirla';
      });
      return;
    }
    try {
      final url = await CloudinaryService.uploadImage(
        widget.selectedImageBytes!,
        '${widget.name}_image.jpg',
      );
      setState(() {
        _imageUrl = url;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen subida con éxito: $url')),
      );
    } catch (e) {
      setState(() {
        _imageError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_imageUrl != null)
              Image.network(_imageUrl!)
            else
              const Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 100,
              ),
            if (_imageError != null)
              Text(_imageError!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Subir Imagen'),
            ),
            TextFormField(
              controller: _adminNameController,
              decoration: const InputDecoration(labelText: 'Nombre del Administrador'),
            ),
            TextFormField(
              controller: _adminEmailController,
              decoration: const InputDecoration(labelText: 'Correo del Administrador'),
            ),
          ],
        ),
      ),
    );
  }
}
