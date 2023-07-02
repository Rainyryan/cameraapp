import 'dart:io'; // we need the File class for showing the image
import 'package:camera/camera.dart'; // Camera package
import 'package:gallery_saver/gallery_saver.dart'; // used to save image to photo Library

import 'package:flutter/material.dart'; // Flutter material design library

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras; // List to store available cameras
  CameraDescription? selectedCamera;
  CameraController? controller; // Camera controller to interact with the camera
  XFile? image; // Variable to store the captured image

  Map<String, String> cameraNameMapping = {};

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras(); // Get available cameras

    cameraNameMapping = {
      for (int i = 0; i < cameras!.length; i++)
        cameras![i].name:
            "Camera ${i + 1} (${cameras![i].lensDirection == CameraLensDirection.back ? "back" : "front"})"
    }; // define the camera name mapping as we load cameras

    if (cameras != null) {
      selectedCamera = cameras![0]; // Select the first available camera
      controller = CameraController(selectedCamera!, ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.bgra8888);
      // Initialize the controller with the first camera in the list
      print(cameras);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {}); // Update the UI after initializing the controller
      });
    } else {
      print("NO camera found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          title: Text("Camera App (test)"), // App bar title
          backgroundColor: Colors.deepOrangeAccent, // App bar color
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                child: controller == null
                    ? Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CameraPreview(controller!),
              ),
              Container(
                child: image == null
                    ? Text("No image captured")
                    : Image.file(
                        File(image!.path),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          alignment: Alignment.bottomRight,
          width: 280,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            DropdownButton<CameraDescription>(
              value: selectedCamera,
              onChanged: (CameraDescription? newValue) {
                setState(() {
                  selectedCamera = newValue;
                  controller = CameraController(
                      selectedCamera!, ResolutionPreset.max,
                      imageFormatGroup: ImageFormatGroup.bgra8888);
                  controller!.initialize().then((_) {
                    if (!mounted) {
                      return;
                    }
                    setState(
                        () {}); // Update the UI after initializing the controller
                  });
                });
              },
              items: cameras?.map<DropdownMenuItem<CameraDescription>>(
                  (CameraDescription camera) {
                String cameraText =
                    cameraNameMapping[camera.name] ?? "Unknown Camera";

                return DropdownMenuItem<CameraDescription>(
                  value: camera,
                  child: Text(cameraText),
                );
              }).toList(),
            ),
            FloatingActionButton(
                onPressed: () async {
                  if (image != null) {
                    await GallerySaver.saveImage(image!.path);
                  }
                },
                backgroundColor: Colors.deepOrangeAccent,
                child: Icon(Icons.save)),
            FloatingActionButton(
              onPressed: () async {
                try {
                  if (controller != null) {
                    if (controller!.value.isInitialized) {
                      image = await controller!.takePicture(); // Capture image
                      setState(
                          () {}); // Update the UI after capturing the image
                    }
                  }
                } catch (e) {
                  print(e);
                }
              },
              backgroundColor: Colors.deepOrangeAccent,
              child: Icon(Icons.camera),
            )
          ]),
        ));
  }
}
