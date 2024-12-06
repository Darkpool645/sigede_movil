import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({super.key});

  @override
  State<CustomInput> createState() => _CustomImputState();
}

class _CustomImputState extends State<CustomInput> {
  bool _isLight = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ingresa un nombre para el campo',
                    hintText: 'Ingresa un nombre para el campo'
                  )
                ),
              ),
              Row(
                children: [
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     labelText: ''
                  //   ),
                  // )
                  Switch(
                    value: _isLight,
                    activeColor: Colors.green,
                    onChanged: (bool value) {
                          setState(() {
                            _isLight = value;
                          });
                      }
                  ),
                  const Text('Mostrar en QR', style: TextStyle(fontSize: 10),),
                  IconButton(
                    onPressed: (){
                      print('Eliminado');
                    },
                    icon: const Icon(Icons.remove_circle_outline_outlined,color: Color.fromARGB(255, 181, 12, 0),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}