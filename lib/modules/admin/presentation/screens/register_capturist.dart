import 'package:flutter/material.dart';
import 'package:sigede_movil/config/locator.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/post_capturista.dart';
import 'package:sigede_movil/widgets.dart/loading_widget.dart';
import 'package:sigede_movil/widgets.dart/success_dialog.dart';

class RegisterCapturist extends StatefulWidget {
  const RegisterCapturist({super.key});

  @override
  State<RegisterCapturist> createState() => _RegisterCapturistState();
}

class _RegisterCapturistState extends State<RegisterCapturist> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late PostCapturista postCapturista;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    postCapturista = sl<PostCapturista>();
  }

  Future<void> _registerCapturista()async{
    try {
      setState(() {
        isLoading=true;
      });
      // OBTENER EL ID DE LA INSTITUCION MEDIANTE EL SHARE PREFERENCES PARA ENVIARLO A postCapturista.call()
      final response = await postCapturista.call(name: _nameController.text, email: _emailController.text, fkInstitution: 1);
      print('LLEGO _registerCapturista: $response');
      setState(() {
        isLoading=false;
      });
      await showSuccessDialog(context: context, message: "Capturista registrado correctamente");
      Navigator.pushReplacementNamed(context, '/navigation'); 
    } catch (e) {
      print('Error en _registerCapturista: $e');
    }
  }

  String? validateEmail(String? value) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un correo electrónico';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Por favor, ingrese un correo electrónico válido';
    }
    return null;
  }

  String? validateName(String? value) {
    final RegExp nameRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingrese un nombre';
    } else if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    } else if (!nameRegExp.hasMatch(value)) {
      return 'El nombre solo debe contener letras y espacios';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Registrar',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Capturista',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Logo-utez.png/460px-Logo-utez.png',
                      height: 90,
                      width: 110,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Universidad Tecnológica Emiliano Zapata',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    TextFormField(
                      validator: validateName,
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre del Capturista',
                          hintText: 'Nombre del Capturista',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          suffixIcon: Icon(Icons.sensor_occupied_rounded)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: validateEmail,
                      controller: _emailController,
                      decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          hintText: 'Correo electrónico',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          suffixIcon: Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(height: 68),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerCapturista();
                          }
                        },
                        child: isLoading?const LoadingWidget(): const Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
