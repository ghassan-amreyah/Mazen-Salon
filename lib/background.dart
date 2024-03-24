import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bounds) => const LinearGradient(
          colors: [Colors.black, Colors.black38],
          begin: Alignment.bottomCenter,
          end: Alignment.center,
        ).createShader(bounds),
        blendMode: BlendMode.darken,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/cover.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter:
                  ColorFilter.mode(Colors.black26, BlendMode.darken))),
        ));
  }
}
