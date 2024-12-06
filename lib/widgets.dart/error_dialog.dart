// error_dialog.dart
import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String message,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(
          size: 50,
          Icons.error,
          color: Colors.red[600],
        ),        
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            // Centra el contenido dentro de las acciones
            child: SizedBox(
              width: 100,
              height: 40,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
