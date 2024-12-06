import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.flickr(
      leftDotColor: const Color(0xFF917D62),
      rightDotColor: const Color(0xFFFFFFFF),
      size: 30, // Tamaño ajustado para caber en el botón.
    );
  }
}
