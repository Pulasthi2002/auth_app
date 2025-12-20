import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageRepository {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({required bool fromCamera}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      return null;
    }
  }

  Future<File?> compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf('.');
      final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 80,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      if (result == null) return file;

      return File(result.path);
    } catch (e) {
      return file;
    }
  }

  Future<String> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      return '';
    }
  }

  Future<String?> pickAndProcessImage({required bool fromCamera}) async {
    final pickedFile = await pickImage(fromCamera: fromCamera);
    if (pickedFile == null) return null;

    final compressedFile = await compressImage(pickedFile);
    if (compressedFile == null) return null;

    final base64String = await imageToBase64(compressedFile);
    return base64String.isEmpty ? null : base64String;
  }
}
