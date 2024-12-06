import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sigede_movil/config/locator.dart';
import 'package:sigede_movil/modules/admin/data/models/simple_capturista.dart';
import 'package:sigede_movil/modules/admin/domain/use_cases/get_capturistas.dart';

class ManagementCapturist extends StatefulWidget {
  const ManagementCapturist({super.key});

  @override
  State<ManagementCapturist> createState() => _ManagementCapturistState();
}

class _ManagementCapturistState extends State<ManagementCapturist> {
  late GetCapturistas getCapturistas;
  List<SimpleCapturista> capturistas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getCapturistas = sl<GetCapturistas>();
    _loadCapturistas();
  }

  Future<void> _loadCapturistas() async {
  try {

    // ESTATICO CAMBIAR
    final role = "capturista";
    final institutionId = 1;

    final users = await getCapturistas.call(
      role: role,
      institutionId: institutionId,
    );

    setState(() {
      capturistas = users;
      isLoading = false;
      if (users.isEmpty) {
        errorMessage = 'No se encontraron capturistas.';
      }
    });
  } on DioException catch (e) {
    setState(() {
      isLoading = false;
      errorMessage = 'Error al cargar los capturistas';
    });
    debugPrint('DioError: ${e.type} - ${e.message}');
    if (e.response != null) {
      debugPrint('DioError response: ${e.response!.data}');
      debugPrint('DioError status code: ${e.response!.statusCode}');
    } else {
      debugPrint('DioError no response: ${e.error}');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Capturistas',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              SizedBox(height: 18,),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: TextField(
                        decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            hintText: 'Buscar capturista',
                            labelText: 'Buscar capturista'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const CircularProgressIndicator()
              else if (errorMessage != null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                )
              else if (capturistas.isEmpty)
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay capturistas disponibles.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: capturistas.map((capturista) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 6.0,horizontal: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/editCapturist',
                                arguments: capturista.userId,
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.account_circle,
                                        ),
                                        title: Text(
                                          capturista.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          capturista.email,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/registerCapturist');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
