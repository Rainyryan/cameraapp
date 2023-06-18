import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Ensure that plugin services are initialized before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of available cameras on the device
  final cameras = await availableCameras();

  // Select the first camera from the list
  final camera = cameras.first;

  runApp(MyApp(camera: camera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(camera: camera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Create a CameraController instance
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Initialize the controller and store the Future for later use
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the screen is disposed
    _controller.dispose();
    super.dispose();
  }

  Future<String> takePicture() async {
    if (!_controller.value.isInitialized) {
      return '';
    }

    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/${DateTime.now()}.png';

    try {
      await _initializeControllerFuture;
      await _controller.takePicture(filePath);
    } catch (e) {
      print('Error capturing image: $e');
      return '';
    }

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          final filePath = await takePicture();
          if (filePath.isNotEmpty) {
            // Navigate to a new screen to display the captured image
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageScreen(imagePath: filePath),
              ),
            );
          } else {
            // Handle error when capturing image
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Failed to capture image.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imagePath;

  const ImageScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
