import 'package:flutter/material.dart';

class Administratormanagementscreen extends StatefulWidget {
  const Administratormanagementscreen({super.key});

  @override
  State<Administratormanagementscreen> createState() =>
      _AdministratormanagementscreenState();
}

class _AdministratormanagementscreenState
    extends State<Administratormanagementscreen> {
  final TextEditingController _searchInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? inputValidation(String? value) {
    final RegExp nameRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

    if (value == null || value.isEmpty) {
      return "Este campo es obligatorio";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Solo se permiten letras y acentos";
    }

    return null;
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
      body: Container(
        color: const Color(0xFFE4E4E4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Gestion de administradores",
                style: TextStyle(fontSize: 22),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // El campo de texto
                      Expanded(
                        child: TextFormField(
                          controller: _searchInput,
                          decoration: const InputDecoration(
                            hintText: "Ingresa el nombre de la empresa",
                            label: Text("Nombre de la empresa"),
                          ),
                          keyboardType: TextInputType.text,
                          validator: inputValidation,
                        ),
                      ),
                      const SizedBox(width: 10),

                      IconButton(
                          onPressed: () {
                            print("REALIZAR CONSULTA O FILTRO");
                          },
                          icon: const Icon(Icons.search))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
                        spreadRadius: 2, // Extensión de la sombra
                        blurRadius: 6, // Difuminado de la sombra
                        offset: Offset(0, 3), // Posición de la sombra (x, y)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Logo-utez.png/300px-Logo-utez.png",
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Universidad Tecnológica Emiliano Zapata",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Administrador",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "San Marcos de la O Fonseca",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
                        spreadRadius: 2, // Extensión de la sombra
                        blurRadius: 6, // Difuminado de la sombra
                        offset: Offset(0, 3), // Posición de la sombra (x, y)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Logo-utez.png/300px-Logo-utez.png",
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Universidad Tecnológica Emiliano Zapata",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Administrador",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "San Marcos de la O Fonseca",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Mandar a pantalla de registro");
        },
        backgroundColor: const Color(0xFF47649D),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
