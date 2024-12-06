import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class ValidationPasswordScreen extends StatefulWidget {
  final String email;

  const ValidationPasswordScreen({super.key, required this.email});

  @override
  State<ValidationPasswordScreen> createState() =>
      _ValidationPasswordScreenState();
}

class _ValidationPasswordScreenState extends State<ValidationPasswordScreen> {
  final List<TextEditingController> _controllers =
      List.generate(8, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(8, (_) => FocusNode()); // Agregamos FocusNodes
  Timer? _timer;
  int _remainingTime = 120; // 2 minutos

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onVerify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 8) {
      // Aquí puedes manejar la verificación del código
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, ingresa los 8 caracteres."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Verification Code",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verification Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252B5C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We have sent an 8-character verification code.\nPlease enter it below.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF53587A)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(8, (index) {
                return SizedBox(
                  width: 40,
                  height: 50,
                  child: RawKeyboardListener(
                    focusNode: _focusNodes[index],
                    onKey: (RawKeyEvent event) {
                      // Si presionamos la tecla "Backspace" en un campo vacío, mover al anterior
                      if (event.logicalKey == LogicalKeyboardKey.backspace &&
                          _controllers[index].text.isEmpty &&
                          index > 0) {
                        FocusScope.of(context).requestFocus(
                            _focusNodes[index - 1]); // Mover al campo anterior
                      }
                    },
                    child: TextField(
                      controller: _controllers[index],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF252B5C),
                        height: 1.5, // Centra verticalmente
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 7) {
                            FocusScope.of(context).requestFocus(
                                _focusNodes[index + 1]); // Mover al siguiente input
                          } else {
                            FocusScope.of(context).unfocus(); // Quitar el foco
                          }
                        } else {
                          if (index > 0) {
                            FocusScope.of(context).requestFocus(
                                _focusNodes[index - 1]); // Mover al campo anterior si se borra
                          }
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: const Color(0xFFF6F9FF),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF252B5C),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF252B5C),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF252B5C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "VERIFY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _remainingTime > 0
                  ? "Wait ${_formatTime(_remainingTime)} seconds to send a new code"
                  : "You can resend the code now.",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF53587A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
