import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// File storage implementation
class FileStorageImpl {
  /// Create a file storage instance with specified category as root directory.
  ///
  /// If the directory does not exist, it will be created.
  static Future<FileStorageImpl> create(String category) async {
    final Directory rootDir = await getApplicationDocumentsDirectory();
    final Directory categoryDir = Directory(join(rootDir.path, category));

    if (!(await categoryDir.exists())) {
      await categoryDir.create();
    }

    return FileStorageImpl._(categoryDir);
  }

  /// Root directory of file storage
  final Directory _root;

  /// private constructor
  const FileStorageImpl._(this._root);

  /// Check if a file exists.
  bool exist(String filename) {
    final f = File(join(_root.path, filename));
    return f.existsSync();
  }

  /// Get file path by filename, return `null` if not exist.
  String? getFilePath(String filename) {
    final f = File(join(_root.path, filename));
    return f.existsSync() ? f.path : null;
  }

  /// Get file binary data by filename, return `null` if not exist.
  Uint8List? getFileBinary(String filename) {
    final f = File(join(_root.path, filename));
    return f.existsSync() ? f.readAsBytesSync() : null;
  }

  /// Write binary data to file, return the path.
  String write(String filename, List<int> bytes) {
    final f = File(join(_root.path, filename));
    f.writeAsBytesSync(bytes);
    return f.path;
  }

  /// Delete a file, return `true` if the file exists.
  bool delete(String filename) {
    final f = File(join(_root.path, filename));
    if (f.existsSync()) {
      f.deleteSync();
      return true;
    }
    return false;
  }

  /// List all files in the storage.
  Iterable<File> list() {
    return _root.listSync().whereType<File>();
  }
}
