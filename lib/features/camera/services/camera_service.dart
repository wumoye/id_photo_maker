import 'package:camera/camera.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  CameraController? controller;
  List<CameraDescription> cameras = [];

  Future<void> initialize() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    controller = CameraController(
      cameras[cameras.length > 1 ? 1 : 0],  // 如果有前置摄像头就用前置，否则用后置
      ResolutionPreset.high,
      enableAudio: false,
    );
    
    await controller?.initialize();
  }

  void dispose() {
    controller?.dispose();
  }
}