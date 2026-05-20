import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SelectableText(
            'Hello World! This is me doing stuff in LazyVIM on ubuntu which should be much faster than normal NeoVIM',
          ),
        ),
      ),
    );
  }
}
