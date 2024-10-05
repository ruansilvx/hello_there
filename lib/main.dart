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

class _MainAppState extends State<MainApp> {
  Color color = Colors.white;

  void changeColor() {
    setState(() {
      color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: changeColor,
        child: Scaffold(
          backgroundColor: color,
          body: const Center(
            child: Text('Hello there'),
          ),
        ),
      ),
    );
  }
}
