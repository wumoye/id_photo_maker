import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../core/routes/app_routes.dart';
import '../services/camera_service.dart';  // 修正导入路径

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraService _cameraService = CameraService();
  bool _isInitialized = false;
  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameraService.cameras.length < 2) return;
    
    final int newIndex = _isFrontCamera ? 0 : 1;
    await _cameraService.controller?.dispose();
    
    _cameraService.controller = CameraController(
      _cameraService.cameras[newIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    
    await _cameraService.controller?.initialize();
    if (mounted) {
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraService.controller!.value.isInitialized) return;
    
    try {
      final XFile photo = await _cameraService.controller!.takePicture();
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.editor,
          arguments: File(photo.path),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('拍摄证件照'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraService.controller!),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios),
                  onPressed: _switchCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 40),
                  onPressed: _takePicture,
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () {
                    // TODO: 打开相册
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}