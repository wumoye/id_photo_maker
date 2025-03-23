import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/photo_action_button.dart';
import '../enums/photo_size.dart';
import '../services/photo_type_processor.dart';
import '../services/photo_save_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PhotoEditorPage extends StatefulWidget {
  final File imageFile;

  const PhotoEditorPage({super.key, required this.imageFile});

  @override
  State<PhotoEditorPage> createState() => _PhotoEditorPageState();
}

class _PhotoEditorPageState extends State<PhotoEditorPage> {
  final PhotoTypeProcessor _processor = PhotoTypeProcessor();
  final PhotoSaveService _saveService = PhotoSaveService();
  File? _processedImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // 初始化时设置默认尺寸为一寸照
    _setDefaultSize();
  }

  Future<void> _setDefaultSize() async {
    setState(() => _isProcessing = true);
    try {
      _processedImage = await _processor.processOneInch(widget.imageFile);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '←',  // 使用文本箭头替代图标
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: const Text(
          '编辑照片',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: _isProcessing ? null : _savePhoto,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '✓',  // 使用文本对勾替代图标
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _processedImage != null
                    ? Image.file(_processedImage!)
                    : Image.file(widget.imageFile),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PhotoActionButton(
                  text: '一寸照',
                  onPressed: () => _handlePhotoSize(PhotoSize.oneInch),
                ),
                PhotoActionButton(
                  text: '二寸照',
                  onPressed: () => _handlePhotoSize(PhotoSize.twoInch),
                ),
                PhotoActionButton(
                  text: '证件照',
                  onPressed: () => _handlePhotoSize(PhotoSize.idPhoto),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _currentPhotoType = 'one_inch';

  // 删除未使用的 _processImage 和 _openGallery 方法

  Future<void> _handlePhotoSize(PhotoSize size) async {
    setState(() => _isProcessing = true);
    try {
      _processedImage = await switch (size) {
        PhotoSize.oneInch => _processor.processOneInch(widget.imageFile),
        PhotoSize.twoInch => _processor.processTwoInch(widget.imageFile),
        PhotoSize.idPhoto => _processor.processIDPhoto(widget.imageFile),
      };
      _currentPhotoType = switch (size) {
        PhotoSize.oneInch => 'one_inch',
        PhotoSize.twoInch => 'two_inch',
        PhotoSize.idPhoto => 'id_photo',
      };
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // 添加保存照片方法
  Future<void> _savePhoto() async {
    if (_processedImage == null) return;

    try {
      final savedPath = await _saveService.savePhoto(_processedImage!);

      if (!mounted) return;

      final typeName = switch (_currentPhotoType) {
        'one_inch' => '一寸照',
        'two_inch' => '二寸照',
        'id_photo' => '证件照',
        _ => '照片',
      };

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: '$typeName 已保存到：$savedPath',  // 显示保存路径
        ),
      );

      Navigator.of(context).pop(savedPath);
    } catch (e) {
      if (!mounted) return;

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: '保存失败: ${e.toString()}'),
      );
    }
  }
}
