import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterCredential extends StatefulWidget {
  const RegisterCredential({super.key});

  @override
  State<RegisterCredential> createState() => _RegisterCredentialState();
}

class _RegisterCredentialState extends State<RegisterCredential> {

  File ? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source)async{
    final pickedFile = await _picker.pickImage(source: source);
    if(pickedFile!=null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Registrar Credencial',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (context){
                        return Container(
                          height: 120,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Text('Selecciona una opcion'),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.camera);
                                    },
                                    label: const Text('Camara'),
                                    icon: const Icon(Icons.camera),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      _pickImage(ImageSource.gallery);
                                    },
                                    label: const Text('Galeria'),
                                    icon: const Icon(Icons.photo_library),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image==null?const Icon(Icons.add_a_photo,size: 50,color: Colors.grey,):ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.file(_image!,fit: BoxFit.cover,),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}