import 'package:flutter/material.dart'; // Flutter material design library
import 'package:local_lens_app/tts_test.dart';
import 'google_ml_kit_text_detection/text_detector_view.dart';
import 'tts_test.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextRecognizerView(), // Set Home widget as the home of the app
      // home: MyHomePage(),
    );
  }
}
