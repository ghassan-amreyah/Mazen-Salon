import 'package:flutter/material.dart';

class BookBackground extends StatelessWidget {
  const BookBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bounds) => const LinearGradient(
              colors: [Colors.black38, Colors.black38],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ).createShader(bounds),
        blendMode: BlendMode.darken,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(
                "https://i.pinimg.com/564x/2b/9f/35/2b9f3508b2e141e3cdec78fe6ff771e9.jpg"),
            fit: BoxFit.cover,
          )),
        ));
  }
}
