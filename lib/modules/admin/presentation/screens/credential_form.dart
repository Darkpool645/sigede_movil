import 'package:flutter/material.dart';
import 'package:sigede_movil/modules/admin/presentation/widgets/custom_input.dart';

class CredentialForm extends StatefulWidget {
  const CredentialForm({super.key});

  @override
  State<CredentialForm> createState() => _CredentialFormState();
}

class _CredentialFormState extends State<CredentialForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Credenciales'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                 const Text('Vigencia'),
                 TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Vigencia',
                    hintText: 'Vigencia'
                  )
                 ),
                ],
              ),
              const SizedBox(height: 20),
              const CustomInput()
            ],
          ),
        ),
      ),
    );
  }
}