import 'dart:io';
import 'package:flutter/material.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/camera/pages/camera_page.dart';
import '../../features/photo/pages/photo_editor_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String camera = '/camera';
  static const String editor = '/editor';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomePage(),
      camera: (context) => const CameraPage(),
      editor: (context) => PhotoEditorPage(
        imageFile: ModalRoute.of(context)!.settings.arguments as File,
      ),
    };
  }
}