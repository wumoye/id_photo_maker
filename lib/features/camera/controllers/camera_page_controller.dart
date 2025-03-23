import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../services/camera_service.dart';
import '../../../features/photo/services/photo_save_service.dart';
import '../../../core/routes/app_routes.dart';

class CameraPageController {
  final CameraService _cameraService = CameraService();
  final PhotoSaveService _saveService = PhotoSaveService();
  final ImagePicker _picker = ImagePicker();
  bool _isFrontCamera = true;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  CameraController? get cameraController => _cameraService.controller;

  Future<void> initialize() async {
    await _cameraService.initialize();
    _isInitialized = true;
  }

  void dispose() {
    _cameraService.dispose();
  }

  Future<void> switchCamera() async {
    if (_cameraService.cameras.length < 2) return;
    
    final int newIndex = _isFrontCamera ? 0 : 1;
    await _cameraService.controller?.dispose();
    
    _cameraService.controller = CameraController(
      _cameraService.cameras[newIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    
    await _cameraService.controller?.initialize();
    _isFrontCamera = !_isFrontCamera;
  }

  Future<void> takePicture(BuildContext context) async {
    if (!_cameraService.controller!.value.isInitialized) return;
    
    try {
      final XFile photo = await _cameraService.controller!.takePicture();
      final String savedPath = await _saveService.savePhoto(File(photo.path));
      
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.editor,
          arguments: File(savedPath),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: '拍照失败: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> openGallery(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.editor,
          arguments: File(image.path),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: '打开相册失败: ${e.toString()}'),
        );
      }
    }
  }
}