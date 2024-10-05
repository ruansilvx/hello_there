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
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> curvedAnimation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOut,
  );

  Color color = Colors.white;
  Color establishedColor = Colors.white;
  Offset startPoint = Offset.zero;

  void changeColor(TapDownDetails tapDetails) {
    setState(() {
      startPoint = tapDetails.localPosition;
      color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);
    });
    controller.reset();
    controller.forward();
  }

  void updateBackgroundListener(AnimationStatus status) {
    if (status.isCompleted) {
      setState(() {
        establishedColor = color;
      });
    }
  }

  @override
  void initState() {
    controller.addStatusListener(updateBackgroundListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeStatusListener(updateBackgroundListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTapDown: changeColor,
        child: Scaffold(
          backgroundColor: establishedColor,
          body: CustomPaint(
            painter: BackgroundCustomPainter(
              color: color,
              startPoint: startPoint,
              animation: curvedAnimation,
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: curvedAnimation,
                builder: (context, _) {
                  return Transform.rotate(
                    angle: curvedAnimation.value * 2 * pi,
                    child: const Text(
                      'Hello there',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            offset: Offset(1.0, 2.0),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
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
