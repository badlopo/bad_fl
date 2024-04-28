import 'package:image_picker/image_picker.dart';

class SelectResult {
  final String filename;
  final String path;

  const SelectResult({
    required this.filename,
    required this.path,
  });

  toJson() => {'filename': filename, 'path': path};
}

/// image select implementation
abstract class ImageSelectImpl {
  static final ImagePicker _picker = ImagePicker();

  /// internal method to pick image
  static Future<SelectResult?> _pick(ImageSource from) async {
    final XFile? xFile = await _picker.pickImage(source: from);
    if (xFile == null) return null;
    return SelectResult(filename: xFile.name, path: xFile.path);
  }

  /// select image from gallery
  static Future<SelectResult?> fromGallery() => _pick(ImageSource.gallery);

  /// select image from camera
  static Future<SelectResult?> fromCamera() => _pick(ImageSource.camera);
}
