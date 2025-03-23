import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import '../widgets/camera_controls.dart';
import '../styles/camera_styles.dart';
import '../controllers/camera_page_controller.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _controller = CameraPageController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _controller.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('拍摄证件照', style: CameraStyles.appBarStyle),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: CameraStyles.cameraPreviewStyle,
              child: CameraPreview(_controller.cameraController!),
            ),
          ),
          CameraControls(
            onSwitchCamera: () async {
              await _controller.switchCamera();
              if (mounted) setState(() {});
            },
            onTakePicture: () => _controller.takePicture(context),
            onOpenGallery: () => _controller.openGallery(context),
          ),
        ],
      ),
    );
  }
}
