import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class PickResult {
  final String filename;
  final String path;

  const PickResult({
    required this.filename,
    required this.path,
  });

  Map<String, String> toJson() => {'filename': filename, 'path': path};
}

/// image operation implementation
abstract class ImageOPImpl {
  static final ImagePicker _picker = ImagePicker();

  /// internal method to pick image
  static Future<PickResult?> _pick(ImageSource from) async {
    final XFile? xFile = await _picker.pickImage(source: from);
    if (xFile == null) return null;
    return PickResult(filename: xFile.name, path: xFile.path);
  }

  /// pick image from gallery
  static Future<PickResult?> pickGallery() => _pick(ImageSource.gallery);

  /// pick image from camera
  static Future<PickResult?> pickCamera() => _pick(ImageSource.camera);

  /// save image to gallery
  static Future<bool> saveToGallery(Uint8List buffer) async {
    try {
      await ImageGallerySaver.saveImage(buffer);
      return true;
    } catch (_) {
      return false;
    }
  }
}
