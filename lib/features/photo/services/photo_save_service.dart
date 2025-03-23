import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoSaveService {
  static final PhotoSaveService _instance = PhotoSaveService._internal();
  factory PhotoSaveService() => _instance;
  PhotoSaveService._internal();

  Future<String> savePhoto(File photo) async {
    try {
      await _requestPermissions();
      
      if (!await photo.exists()) {
        throw Exception('照片文件不存在');
      }

      // 使用 photo_manager 保存图片
      final asset = await PhotoManager.editor.saveImageWithPath(
        photo.path,
        title: _generateFileName(),
      );

      if (asset == null) {
        throw Exception('保存到相册失败');
      }

      // 获取文件路径并确保文件存在
      final file = await asset.file;
      if (file == null) {
        throw Exception('无法获取保存的文件路径');
      }
      
      return file.path;
    } catch (e) {
      debugPrint('保存照片失败: $e');
      throw Exception('保存照片失败: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (!permitted.isAuth) {
      throw Exception('需要照片访问权限才能保存照片');
    }
  }

  String _generateFileName() {
    return 'ID_Photo_${DateTime.now().millisecondsSinceEpoch}';
  }
}
