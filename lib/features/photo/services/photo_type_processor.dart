import 'dart:io';
import '../constants/photo_sizes.dart';
import 'photo_processor.dart';

class PhotoTypeProcessor {
  static final PhotoTypeProcessor _instance = PhotoTypeProcessor._internal();
  factory PhotoTypeProcessor() => _instance;
  PhotoTypeProcessor._internal();

  final _processor = PhotoProcessor();

  // 中国标准证件照
  Future<File> processOneInch(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.oneInch.width,
        height: PhotoSizes.oneInch.height,
      );

  Future<File> processTwoInch(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.twoInch.width,
        height: PhotoSizes.twoInch.height,
      );

  Future<File> processIDPhoto(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.idPhoto.width,
        height: PhotoSizes.idPhoto.height,
      );

  // 日本标准证件照
  Future<File> processResidenceCard(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.residenceCard.width,
        height: PhotoSizes.residenceCard.height,
      );

  Future<File> processJapanesePassport(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.passportJP.width,
        height: PhotoSizes.passportJP.height,
      );

  // 国际标准证件照
  Future<File> processSchengenVisa(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.schengenVisa.width,
        height: PhotoSizes.schengenVisa.height,
      );

  Future<File> processUSVisa(File inputFile) => _processor.processPhoto(
        inputFile,
        width: PhotoSizes.usVisa.width,
        height: PhotoSizes.usVisa.height,
      );
}