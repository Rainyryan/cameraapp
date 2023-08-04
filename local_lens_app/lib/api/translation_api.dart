import 'dart:async';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TranslationApi {
  static OnDeviceTranslator? _translator;
  static TranslateLanguage _sourceLanguage = TranslateLanguage.chinese;
  static TranslateLanguage _targetLanguage = TranslateLanguage.english;

  static Future<void> updateTranslator({
    required TranslateLanguage sourceLanguage,
    required TranslateLanguage targetLanguage,
  }) async {
    if (_translator != null) {
      _translator!.close();
    }
    _sourceLanguage = sourceLanguage;
    _targetLanguage = targetLanguage;
    _translator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
    );
  }

  static Future<String?> translateText(String originalText) async {
    try {
      if (_translator == null) {
        await updateTranslator(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        );
      }
      final translatedText = await _translator!.translateText(originalText);
      return translatedText;
    } catch (e) {
      return null;
    }
  }

  static Future<RecognizedText?> translateRecognizedText(RecognizedText recognizedText) async {
    List<Future<TextBlock>> translatedBlockFutures = [];

    for (TextBlock textBlock in recognizedText.blocks) {
      Future<String?> translationFuture = translateText(textBlock.text);
      translatedBlockFutures.add(translationFuture.then((translatedText) {
        if (translatedText != null) {
          return TextBlock(
            text: translatedText,
            lines: textBlock.lines,
            boundingBox: textBlock.boundingBox,
            recognizedLanguages: textBlock.recognizedLanguages,
            cornerPoints: textBlock.cornerPoints,
          );
        } else {
          return Future.value(null);
        }
      }));
    }

    List<TextBlock> translatedBlocks = await Future.wait(translatedBlockFutures);
    translatedBlocks.removeWhere((element) => element == null);

    if (translatedBlocks.isNotEmpty) {
      RecognizedText translatedRecognizedText =
          RecognizedText(text: recognizedText.text, blocks: translatedBlocks);
      return translatedRecognizedText;
    }
    return null;
  }
}
