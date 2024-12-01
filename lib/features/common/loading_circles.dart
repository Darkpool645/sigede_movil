import 'package:flutter/material.dart';

class LoadingCircles extends StatefulWidget {
  const LoadingCircles({super.key});

  @override
  State<LoadingCircles> createState() => _LoadingCirclesState();
}

class _LoadingCirclesState extends State<LoadingCircles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _leftToRight;
  late Animation<double> _rightToLeft;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
    _leftToRight = Tween<double>(begin: -25.0, end: 25.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rightToLeft = Tween<double>(begin: 25.0, end: -25.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_leftToRight.value, 0),
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFFFFFFFF),
                    ),
                  );
                }),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_rightToLeft.value, 0),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF9E9E9E),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
