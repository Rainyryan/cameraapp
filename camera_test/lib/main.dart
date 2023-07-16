import 'package:flutter/material.dart'; // Flutter material design library
import 'home.dart'; // import my class containing the home page design -> Home()
import 'google_ml_kit/text_detector_view.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextRecognizerView(), // Set Home widget as the home of the app
    );
  }
}
