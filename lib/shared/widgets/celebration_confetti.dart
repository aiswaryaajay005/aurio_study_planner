import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CelebrationConfetti extends StatefulWidget {
  const CelebrationConfetti({super.key});

  @override
  State<CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<CelebrationConfetti> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirection: pi / 2,
        maxBlastForce: 10,
        minBlastForce: 5,
        emissionFrequency: 0.05,
        numberOfParticles: 30,
        gravity: 0.2,
        colors: const [Colors.green, Colors.blue, Colors.purple, Colors.orange],
      ),
    );
  }
}
