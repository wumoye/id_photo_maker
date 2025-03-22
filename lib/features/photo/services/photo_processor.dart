import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart' show Color;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class PhotoProcessor {
  static final PhotoProcessor _instance = PhotoProcessor._internal();
  factory PhotoProcessor() => _instance;
  PhotoProcessor._internal();

  Future<File> _createProcessedImage({
    required img.Image source,
    required int width,
    required int height,
    required Color backgroundColor,
  }) async {
    double scale = math.min(
      width / source.width,
      height / source.height,
    );
    
    int newWidth = (source.width * scale).round();
    int newHeight = (source.height * scale).round();

    var resized = img.copyResize(
      source,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear,
    );

    final background = img.Image(width: width, height: height, format: img.Format.uint8);
    img.fill(background, color: img.ColorInt8.rgb(255, 255, 255));

    final x = (width - newWidth) ~/ 2;
    final y = (height - newHeight) ~/ 2;
    img.compositeImage(background, resized, dstX: x, dstY: y);

    return _saveImage(background);
  }

  Future<File> _saveImage(img.Image image) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(image));
    return outputFile;
  }

  Future<File> processPhoto(File inputFile, {
    required int width,
    required int height,
    Color backgroundColor = const Color(0xFFFFFFFF),
  }) async {
    final bytes = await inputFile.readAsBytes();
    var image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    return _createProcessedImage(
      source: image,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
    );
  }
}