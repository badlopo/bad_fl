import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickResult {
  final String filename;
  final String path;

  const ImagePickResult({
    required this.filename,
    required this.path,
  });

  Map<String, String> toJson() => {'filename': filename, 'path': path};

  @override
  String toString() {
    return '[ImagePickResult] $filename ($path)';
  }
}

class ImageSaveResult {
  final bool ok;
  final String? filePath;
  final String? errorMessage;

  ImageSaveResult.fromJson(Map<String, dynamic> json)
      : ok = json['isSuccess'],
        filePath = json['filePath'],
        errorMessage = json['errorMessage'];

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'filePath': filePath,
      'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return ok
        ? '[ImageSaveResult] ok ($filePath)'
        : '[ImageSaveResult] error ($errorMessage)';
  }
}

/// `impl::image_op`: image operation (pick, save)
abstract class BadImageOP {
  static final ImagePicker _picker = ImagePicker();

  /// internal method to pick image
  static Future<ImagePickResult?> _pick(ImageSource from) async {
    final XFile? xFile = await _picker.pickImage(source: from);
    if (xFile == null) return null;
    return ImagePickResult(filename: xFile.name, path: xFile.path);
  }

  /// pick image from gallery
  static Future<ImagePickResult?> pickGallery() => _pick(ImageSource.gallery);

  /// pick image from camera
  static Future<ImagePickResult?> pickCamera() => _pick(ImageSource.camera);

  /// save image to gallery
  static Future<ImageSaveResult> saveToGallery(Uint8List buffer) async {
    try {
      final r = await ImageGallerySaver.saveImage(buffer);
      return ImageSaveResult.fromJson(Map<String, dynamic>.from(r));
    } catch (err) {
      return ImageSaveResult.fromJson(
          {'isSuccess': false, 'errorMessage': '$err'});
    }
  }
}
