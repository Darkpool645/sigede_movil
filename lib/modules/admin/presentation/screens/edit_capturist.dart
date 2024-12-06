import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sigede_movil/config/locator.dart';
import 'package:sigede_movil/modules/admin/data/models/capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/disable_capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/get_capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/put_capturista.dart';
import 'package:sigede_movil/widgets.dart/loading_widget.dart';
import 'package:sigede_movil/widgets.dart/success_dialog.dart';

class EditCapturist extends StatefulWidget {
  const EditCapturist({super.key});

  @override
  State<EditCapturist> createState() => _EditCapturistState();
}

class _EditCapturistState extends State<EditCapturist> {
  late int userAccountId;
  late GetCapturista getCapturista;
  late PutCapturista putCapturista;
  late DisableCapturista disableCapturista;
  Capturista? capturista;
  bool light = true;
  bool isLoading = true;
  bool isUpdating=false;
  bool? isActive;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCapturista = sl<GetCapturista>();
    putCapturista = sl<PutCapturista>();
    disableCapturista = sl<DisableCapturista>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = ModalRoute.of(context)?.settings.arguments as int?;
    if (userId != null) {
      userAccountId = userId;
      _loadCapturista();
    } else {
      print("Error: No se ha proporcionado un userId didChangeDependencies metodo");
      Navigator.pushReplacementNamed(context, '/navigation');
    }
  }

  Future<void> _loadCapturista() async {
  try {
    final user = await getCapturista.call(userId: userAccountId);
    setState(() {
      capturista = user;
      isLoading = false;
      _nameController.text = capturista!.name;
      _emailController.text = capturista!.email;
      isActive = capturista!.status == 'activo';
    });
    } on DioException catch (e) {
    setState(() {
      isLoading = false;
    });
    print("Error $e");
  }
  }

  Future<void> _updateStatusCapturista(String email, String status)async{
    try {
      if((capturista?.status=='activo')!=isActive){
        final response = await disableCapturista.call(email: email, status: status);
        print('DESDE _updateStatusCapturista: $response');
      }else{
        print('No hubo cambio de estado');
      }
    } catch (e) {
      print('Error en _updateStatusCapturista $e');
    }
  }

  Future<String> _validateStatus()async{
    try {
      return isActive!?'inactivo':'activo';
    } catch (e) {
      print('Error en _validateStatus: $e');
      return 'inactivo';
    }
  }

  Future<void> _updateCapturista() async {
  try {
    setState(() {
      isUpdating = true;
    });

    String st = await _validateStatus();

    if ((capturista?.status != 'activo' && isActive == true) || 
        (capturista?.status == 'activo' && isActive == false)) {
      await _updateStatusCapturista(_emailController.text, st);
    }

    final response = await putCapturista.call(userId: userAccountId, name: _nameController.text);

    if (response.data['status'] == 200) {
      setState(() {
        isUpdating = false;
      });
      await showSuccessDialog(context: context, message: "Capturista actualizado correctamente");
      Navigator.pushReplacementNamed(context, '/navigation');
    }
  } catch (e) {
    setState(() {
      isUpdating = false;
    });
    print('Error en _updateCapturista $e');
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch(
                          value: isActive ??
                              false, // Si isActive es null, lo considera como false
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Editar Capturista',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
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
                                labelText: 'Nombre de Capturista',
                                hintText: 'Nombre de Capturista',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                suffixIcon:
                                    Icon(Icons.sensor_occupied_rounded)),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            enabled: false,
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
                          const SizedBox(
                            height: 68,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _updateCapturista();
                                }
                              },
                              child: isUpdating? const LoadingWidget():const Text('Editar',style: TextStyle(fontSize: 22),),
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