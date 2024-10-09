import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

/// Starting point of the application.
class MainApp extends StatefulWidget {
  /// Default constructor
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  /// Controls all animations
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  /// Applies curves to make animation smoother
  late final Animation<double> curvedAnimation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOut,
  );

  /// New color for when user taps the screen
  Color newColor = Colors.white;

  /// Current background color
  Color currentColor = Colors.white;

  /// Tap position offset to animate new color circle
  Offset startPoint = Offset.zero;

  /// Captures the tap position offset and provides a new color to animate from
  void changeColor(TapDownDetails tapDetails) {
    final randomizedColor = (Random().nextDouble() * 0xFFFFFF).toInt();
    setState(() {
      startPoint = tapDetails.localPosition;
      // The random formula also randomizes the opacity, so we manually make it
      // opaque
      newColor = Color(randomizedColor).withOpacity(1);
    });
    controller.reset();
    controller.forward();
  }

  /// Updates the background with the new color once the animation is over.
  /// The background won't change otherwise.
  void updateBackgroundListener(AnimationStatus status) {
    if (status.isCompleted) {
      setState(() {
        currentColor = newColor;
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
          body: CustomPaint(
            painter: BackgroundCustomPainter(
              currentColor: currentColor,
              newColor: newColor,
              startPoint: startPoint,
              animation: curvedAnimation,
            ),
            child: _AnimatedCenterText(curvedAnimation: curvedAnimation),
          ),
        ),
      ),
    );
  }
}

/// The center text of the application.
/// The text has a spin animation controlled by [curvedAnimation]
class _AnimatedCenterText extends StatelessWidget {
  /// The default constructor
  const _AnimatedCenterText({
    required this.curvedAnimation,
  });

  /// Manages the text spin animation
  final Animation<double> curvedAnimation;

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  // Shadows give better contrast to the text over most
                  // backgrounds
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
    );
  }
}

/// Draws the background of the application.
/// [currentColor] is the current background color, it's drawn first covering
/// the whole viewport.
/// A circle with color [newColor] and center at [startPoint] is drawn growing
/// in size according to [animation] until fits the entire viewport, covering
/// the current background color.
class BackgroundCustomPainter extends CustomPainter {
  /// The default constructor. All members required.
  BackgroundCustomPainter({
    required this.currentColor,
    required this.newColor,
    required this.animation,
    required this.startPoint,
  }) : super(repaint: animation);

  /// The current backgroundColor
  final Color currentColor;

  /// The color of the animated circle
  final Color newColor;

  /// The center point of the animated circle
  final Offset startPoint;

  /// The animation values to animate the circle
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(currentColor, BlendMode.srcOver);

    final paint = Paint()
      ..color = newColor;

    canvas.drawCircle(
      startPoint,
      (size.longestSide + 50) * animation.value,
      paint,
    );
  }

  @override
  bool shouldRepaint(BackgroundCustomPainter oldDelegate) {
    return oldDelegate.newColor != newColor ||
        oldDelegate.currentColor != currentColor;
  }
}
