import 'dart:io';

import 'package:ai_detection_app/utils/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResultScreen extends StatelessWidget {
  final String image;
  final Map<String, int> result;
  const ResultScreen({super.key, required this.image, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Animate(
        effects: const [FadeEffect(), ScaleEffect()],
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  decoration: roundedBorderBoxDecoration(context: context),
                  child: ClipOval(
                    child: Stack(children: [
                      Image.file(
                        File(image),
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width * 0.7,
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    result.keys.elementAt(0),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 32,
                    ),
                  ),
                ),
                Text(
                  "${result.values.elementAt(0).toString()}%",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 26),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
