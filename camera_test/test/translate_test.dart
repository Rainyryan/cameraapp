import 'package:flutter_test/flutter_test.dart';
import 'package:camera_test/google_ml_kit/translation_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Translation test', () async {
    // Set up the input and expected output
    final String inputText = 'sadfjslfj;as';
    final String expectedOutput =
        'Hello'; // Assuming the translation of 'Hello' to French is 'Bonjour'

    // Call the translation method
    final translatedText = await TranslationApi.translateText(inputText);

    // Verify the translation
    expect(translatedText, expectedOutput);
  });
}
