import 'package:flutter/material.dart';

class CredentialsManagement extends StatefulWidget {
  const CredentialsManagement({super.key});

  @override
  State<CredentialsManagement> createState() => _CredentialsManagementState();
}

class _CredentialsManagementState extends State<CredentialsManagement> {
  FocusNode _focusNode = FocusNode();

  Color _getVigenciaColor(String vigencia) {
    DateTime fechaVigencia = DateTime.parse(vigencia); // Asegúrate de que el formato sea compatible
    DateTime fechaActual = DateTime.now();
    
    return fechaVigencia.isBefore(fechaActual) ? Colors.red : Colors.green;
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
                  'Credenciales',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
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
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                print('Buscando...');
                              },
                              icon: const Icon(Icons.search)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          hintText: 'Buscar credencial',
                          labelText: 'Buscar credencial'),
                      onSubmitted: (value) {
                        print("Se ingresó: $value");
                        _focusNode.unfocus();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: const [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.badge_outlined),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Jose Perez Solano',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines:1,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Vigencia'),
                                    Text(
                                      '22/12/2024',
                                      style: TextStyle(
                                        // color: _getVigenciaColor("2024-12-22"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
