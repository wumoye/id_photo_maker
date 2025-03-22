import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PhotoSaveService {
  static final PhotoSaveService _instance = PhotoSaveService._internal();
  factory PhotoSaveService() => _instance;
  PhotoSaveService._internal();

  Future<String> savePhoto(File photo) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedFile = await photo.copy('${appDir.path}/photos/$fileName');
    return savedFile.path;
  }

  Future<void> ensurePhotoDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${appDir.path}/photos');
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }
  }
}