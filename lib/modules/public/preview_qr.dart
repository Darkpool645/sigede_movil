import 'package:flutter/material.dart';

class PreviewQR extends StatelessWidget {
  const PreviewQR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles Credencial',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2024/07/22/17/11/elegance-in-profile-8913207_640.png'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 6.0, bottom: 6.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 217, 217, 217),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0),
                                bottom: Radius.circular(8.0)),
                          ),
                          child: const Text(
                            'Vigencia',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 12.0,bottom: 8.0),
                        child: TextField(
                          controller: TextEditingController(text: '23-12-2024'),
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                            label: Text('Vigencia'),
                            suffixIcon: Icon(Icons.calendar_today)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for(int i=1;i<=10;i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                            child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                              labelText: 'campo $i'
                            ),
                            controller: TextEditingController(
                              text: 'valor $i'
                            ),
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
    );
  }
}
