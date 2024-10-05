import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> _curvedAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  Color color = Colors.white;
  Offset startPoint = Offset.zero;

  void changeColor(TapDownDetails tapDetails) {
    setState(() {
      startPoint = tapDetails.localPosition;
      color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(.8);
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTapDown: changeColor,
        child: Scaffold(
          body: CustomPaint(
            painter: BackgroundCustomPainter(
              color: color,
              startPoint: startPoint,
              animation: _curvedAnimation,
            ),
            child: const Center(
              child: Text('Hello there'),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundCustomPainter extends CustomPainter {
  BackgroundCustomPainter({
    required this.color,
    required this.animation,
    required this.startPoint,
  }) : super(repaint: animation);

  final Color color;
  final Offset startPoint;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawCircle(
      startPoint,
      (size.longestSide + 50) * animation.value,
      paint,
    );
  }

  @override
  bool shouldRepaint(BackgroundCustomPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
