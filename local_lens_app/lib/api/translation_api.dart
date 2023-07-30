import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:async';

class TranslationApi {
  // static final Map<String, String> _languageCache = {};

  // static Future<String?> identifyLanguage(String recognizedText) async {
  //   if (_languageCache.containsKey(recognizedText)) {
  //     return _languageCache[recognizedText];
  //   }

  //   try {
  //     final langIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  //     final languageCode = await langIdentifier.identifyLanguage(recognizedText);
  //     langIdentifier.close();
  //     _languageCache[recognizedText] = languageCode;
  //     return languageCode;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  static Future<String?> translateText(String recognizedText) async {
    try {
      // final langIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      // final languageCode = await langIdentifier.identifyLanguage(recognizedText);
      // langIdentifier.close();
      final translator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.chinese,
          // TranslateLanguage.values.firstWhere((element) => element.bcpCode == languageCode),
          targetLanguage: TranslateLanguage.english);
      final translatedText = await translator.translateText(recognizedText);
      translator.close();
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

    // static Future<RecognizedText?> translateRecognizedText(RecognizedText recognizedText) async {
    //   List<TextBlock> translatedBlocks = [];

    //   for (TextBlock textBlock in recognizedText.blocks) {
    //     String? translatedText = await translateText(textBlock.text);
    //     if (translatedText != null) {
    //       TextBlock translatedBlock = TextBlock(
    //         text: translatedText,
    //         lines: textBlock.lines,
    //         boundingBox: textBlock.boundingBox,
    //         recognizedLanguages: textBlock.recognizedLanguages,
    //         cornerPoints: textBlock.cornerPoints,
    //       );
    //       translatedBlocks.add(translatedBlock);
    //     }
    //   }

    if (translatedBlocks.isNotEmpty) {
      RecognizedText translatedRecognizedText =
          RecognizedText(text: recognizedText.text, blocks: translatedBlocks);
      return translatedRecognizedText;
    }

    return null;
  }
}
