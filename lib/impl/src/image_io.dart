import 'dart:typed_data';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';

/// Image IO(pick, save) implementation.
abstract class ImageIOImpl {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from camera.
  static Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(source: ImageSource.gallery);
  }

  /// Pick an image from camera.
  static Future<XFile?> pickFromCamera() {
    return _picker.pickImage(source: ImageSource.camera);
  }

  /// Save an image to gallery, return `true` if success.
  static Future<bool> saveToGallery(Uint8List bytes, {String? name}) async {
    final r = await ImageGallerySaverPlus.saveImage(bytes, name: name);

    // OPTIMIZE: return filepath if needed.
    return Map<String, dynamic>.from(r)['isSuccess'];
  }
}
