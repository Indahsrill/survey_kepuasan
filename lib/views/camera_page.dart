import 'package:camera/camera.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:kepuasan_pelanggan/main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late FaceCameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = FaceCameraController(
      autoCapture: false,
      performanceMode: FaceDetectorMode.accurate,
      imageResolution: ImageResolution.high,
      onCapture: (image) {
        print("hOHO");
      },
      onFaceDetected: (face) {
        print("Ada wajah!");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartFaceCamera(
        controller: cameraController,
        // showControls: false,
        showCaptureControl: false,
        message: "Tunggu sebentar...",
        messageStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
