import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final VoidCallback onSwitchCamera;
  final VoidCallback onTakePicture;
  final VoidCallback onOpenGallery;

  const CameraControls({
    super.key,
    required this.onSwitchCamera,
    required this.onTakePicture,
    required this.onOpenGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.camera_rotate, color: Colors.white),
            iconSize: 30,
            onPressed: onSwitchCamera,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.camera_circle_fill, color: Colors.white),
            iconSize: 50,
            onPressed: onTakePicture,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.photo, color: Colors.white),
            iconSize: 30,
            onPressed: onOpenGallery,
          ),
        ],
      ),
    );
  }
}