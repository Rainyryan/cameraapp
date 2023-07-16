import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationApi {
  static Future<String?> translateText(String recognizedText) async {
    try {
      final langIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      final languageCode = await langIdentifier.identifyLanguage(recognizedText);
      langIdentifier.close();
      final translator = OnDeviceTranslator(
          sourceLanguage:
              TranslateLanguage.values.firstWhere((element) => element.bcpCode == languageCode),
          targetLanguage: TranslateLanguage.english);
      final translatedText = await translator.translateText(recognizedText);
      translator.close();
      return translatedText;
    } catch (e) {
      return null;
    }
  }

  static Future<RecognizedText?> translateRecognizedText(RecognizedText recognizedText) async {
    List<TextBlock> translatedBlocks = [];

    for (TextBlock textBlock in recognizedText.blocks) {
      String? translatedText = await translateText(textBlock.text);
      if (translatedText != null) {
        TextBlock translatedBlock = TextBlock(
          text: translatedText,
          lines: textBlock.lines,
          boundingBox: textBlock.boundingBox,
          recognizedLanguages: textBlock.recognizedLanguages,
          cornerPoints: textBlock.cornerPoints,
        );
        translatedBlocks.add(translatedBlock);
      }
    }

    if (translatedBlocks.isNotEmpty) {
      RecognizedText translatedRecognizedText =
          RecognizedText(text: recognizedText.text, blocks: translatedBlocks);
      return translatedRecognizedText;
    }

    return null;
  }
}
