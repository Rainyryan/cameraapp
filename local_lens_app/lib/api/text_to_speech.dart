import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechApi {
  static final FlutterTts _tts = FlutterTts();
  List<String>? languages;

  void init() async {
    languages = List<String>.from(await _tts.getLanguages);
  }

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;

  static Future<void> speak(String text, {String? language}) async {
    await _tts.setLanguage(language ?? 'en-US');
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
