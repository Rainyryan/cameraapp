import 'package:flutter_test/flutter_test.dart';
import 'package:local_lens_app/api/__translation_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Translation test', () async {
    // Set up the input and expected output
    const String inputText = 'sadfjslfj;as';
    const String expectedOutput =
        'Hello'; // Assuming the translation of 'Hello' to French is 'Bonjour'

    // Call the translation method
    final translatedText = await TranslationApi.translateText(inputText);

    // Verify the translation
    expect(translatedText, expectedOutput);
  });
}
