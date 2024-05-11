import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class PickedItem {
  final String filename;
  final String path;

  const PickedItem({
    required this.filename,
    required this.path,
  });

  Map<String, String> toJson() => {'filename': filename, 'path': path};
}

class SaveResult {
  final bool ok;
  final String? filePath;
  final String? errorMessage;

  SaveResult.fromJson(Map<String, dynamic> json)
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
}

/// image operation implementation
abstract class ImageOPImpl {
  static final ImagePicker _picker = ImagePicker();

  /// internal method to pick image
  static Future<PickedItem?> _pick(ImageSource from) async {
    final XFile? xFile = await _picker.pickImage(source: from);
    if (xFile == null) return null;
    return PickedItem(filename: xFile.name, path: xFile.path);
  }

  /// pick image from gallery
  static Future<PickedItem?> pickGallery() => _pick(ImageSource.gallery);

  /// pick image from camera
  static Future<PickedItem?> pickCamera() => _pick(ImageSource.camera);

  /// save image to gallery
  static Future<SaveResult> saveToGallery(Uint8List buffer) async {
    try {
      final r = await ImageGallerySaver.saveImage(buffer);
      return SaveResult.fromJson(Map<String, dynamic>.from(r));
    } catch (err) {
      return SaveResult.fromJson({'isSuccess': false, 'errorMessage': '$err'});
    }
  }
}
