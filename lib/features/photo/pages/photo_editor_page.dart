import 'dart:io';
import 'package:flutter/material.dart';
import '../services/photo_type_processor.dart';
import '../services/photo_save_service.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑照片'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isProcessing ? null : _savePhoto,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _processedImage != null
                ? Image.file(_processedImage!)
                : Image.file(widget.imageFile),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isProcessing ? null : () => _processImage('one_inch'),
                  child: const Text('一寸照'),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : () => _processImage('two_inch'),
                  child: const Text('二寸照'),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : () => _processImage('id_photo'),
                  child: const Text('证件照'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(String type) async {
    setState(() => _isProcessing = true);
    try {
      final processed = await switch (type) {
        'one_inch' => _processor.processOneInch(widget.imageFile),
        'two_inch' => _processor.processTwoInch(widget.imageFile),
        'id_photo' => _processor.processIDPhoto(widget.imageFile),
        _ => throw Exception('Unknown photo type'),
      };
      setState(() => _processedImage = processed);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _savePhoto() async {
    if (_processedImage == null) return;

    try {
      await _saveService.ensurePhotoDirectory();
      final savedPath = await _saveService.savePhoto(_processedImage!);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('照片已保存到: $savedPath')),
      );
      
      Navigator.of(context).pop(savedPath);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存照片失败')),
      );
    }
  }
}