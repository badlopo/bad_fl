import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CachedEntry {
  final String filename;
  final String filepath;
  final int bytes;

  const CachedEntry(this.filename, this.filepath, this.bytes);

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'filepath': filepath,
      'bytes': bytes,
    };
  }

  @override
  String toString() {
    return '[CachedEntry] $filename ($bytes bytes)';
  }
}

/// cache file to `file_cache` folder under `getApplicationDocumentsDirectory` returned directory
/// - iOS: `NSDocumentDirectory`
/// - Android: `getDataDirectory()`
abstract class CacheImpl {
  static Directory? _root;

  /// initialization
  static Future<bool> prepare() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      dir = Directory(join(dir.path, 'file_cache'));

      // create cache dir if not exist
      if (!dir.existsSync()) dir.createSync();

      // assign cache dir
      _root = dir;
      return true;
    } catch (_) {
      return false;
    }
  }

  static ResultType _task<ResultType>(
    ResultType Function() task,
    ResultType resultOnError,
  ) {
    if (_root == null) {
      throw Exception('"prepare" must be called first before any operation.');
    }
    try {
      return task();
    } catch (_) {
      return resultOnError;
    }
  }

  /// check if file exists
  static bool exist(String filename) {
    return _task(() => File(join(_root!.path, filename)).existsSync(), false);
  }

  /// get path of file, return null if not exist
  static String? getPath(String filename) {
    return _task(() {
      final f = File(join(_root!.path, filename));
      return f.existsSync() ? f.path : null;
    }, null);
  }

  /// get binary content of file, return null if not exist
  static Uint8List? getBinary(String filename) {
    return _task(() {
      final f = File(join(_root!.path, filename));
      return f.existsSync() ? f.readAsBytesSync() : null;
    }, null);
  }

  /// put binary content to file, return the path if success, otherwise null
  static String? put(String filename, List<int> bytes) {
    return _task(() {
      final f = File(join(_root!.path, filename));
      f.writeAsBytesSync(bytes);
      return f.path;
    }, null);
  }

  /// remove cached file
  ///
  /// - return `true` if file exists and removed successfully
  /// - return `false` if file not exist
  /// - return `null` if error occurred
  static bool? remove(String filename) {
    return _task(() {
      final f = File(join(_root!.path, filename));
      if (f.existsSync()) {
        f.deleteSync();
        return true;
      }
      return false;
    }, null);
  }

  /// list all cached files, return null if error occurred
  static List<CachedEntry>? files() {
    return _task(() {
      List<CachedEntry> entries = [];
      for (var entry in _root!.listSync()) {
        if (entry is File) {
          entries.add(CachedEntry(
            basename(entry.path),
            entry.path,
            entry.lengthSync(),
          ));
        }
      }
      return entries;
    }, null);
  }
}
