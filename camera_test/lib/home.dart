import 'dart:io'; // Import necessary packages
import 'package:camera/camera.dart'; // Camera package
import 'package:gallery_saver/gallery_saver.dart';

import 'package:flutter/material.dart'; // Flutter material design library

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription>? cameras; // List to store available cameras
  CameraController? controller; // Camera controller to interact with the camera
  XFile? image; // Variable to store the captured image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras(); // Get available cameras
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max,
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
          title: Text("Live Camera Preview"), // App bar title
          backgroundColor: Colors.redAccent, // App bar color
        ),
        body: Container(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // scrollable: true,
            children: [
              Container(
                // height: 300,
                child: controller == null
                    ? Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CameraPreview(controller!),
              ),
              Container(
                // padding: EdgeInsets.all(30),
                child: image == null
                    ? Text("No image captured")
                    : Image.file(
                        File(image!.path),
                        // height: 300,
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          alignment: Alignment.bottomRight,
          width: 120,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FloatingActionButton(
                onPressed: () async {
                  if (image != null) {
                    await GallerySaver.saveImage(image!.path);
                  }
                },
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
              child: Icon(Icons.camera),
            )
          ]),
        ));
  }
}
