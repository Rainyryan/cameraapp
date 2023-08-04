import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'detector_view.dart';
import 'text_detector_painter.dart';
import '../api/translation_api.dart';
import '../api/text_to_speech.dart';

class TextRecognizerView extends StatefulWidget {
  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  var _script = TextRecognitionScript.chinese;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFFFE4C7), // Creamy Orange color
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: DetectorView(
              title: 'Local Lens v1',
              customPaint: _customPaint,
              text: _text,
              onImage: _processImage,
              initialCameraLensDirection: _cameraLensDirection,
              onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
            ),
          ),
          Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE4C7), // Creamy Orange color
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildDropdown(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFE4C7), // Creamy Orange color
                ),
                onPressed: () => TextToSpeechApi.speak("hello ryan"), //_captureImage,
                child: Text('test tts'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() => DropdownButton<TextRecognitionScript>(
        value: _script,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.white),
        underline: Container(
          height: 2,
          color: Colors.white,
        ),
        onChanged: (TextRecognitionScript? script) {
          if (script != null) {
            setState(() {
              _script = script;
              _textRecognizer.close();
              _textRecognizer = TextRecognizer(script: _script);
            });
          }
        },
        dropdownColor: Color.fromARGB(178, 255, 228, 199),
        items: TextRecognitionScript.values.map<DropdownMenuItem<TextRecognitionScript>>((script) {
          return DropdownMenuItem<TextRecognitionScript>(
            value: script,
            child: Text(
              script.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      );

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    await Future.delayed(const Duration(seconds: 2));
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final translatedText = await TranslationApi.translateRecognizedText(recognizedText);
    final resultText = translatedText ?? recognizedText;
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(
        resultText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Recognized text:\n\n${resultText.text}';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _captureImage() async {
    final imageFile = await _cameraController.takePicture();
    await GallerySaver.saveImage(imageFile.path);
  }
}
