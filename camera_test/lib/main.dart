import 'package:flutter/material.dart'; // Flutter material design library
import 'home.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(), // Set Home widget as the home of the app
    );
  }
}