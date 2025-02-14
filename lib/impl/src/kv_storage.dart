import 'package:bad_fl/core.dart';
import 'package:hive_ce_flutter/adapters.dart';

/// Key-Value storage implementation.
abstract class KVStorageImpl {
  /// Hive box instance.
  static Box? _box;

  static Iterable<String> get keys {
    assert(_box != null, 'call "prelude" first');
    return _box!.keys.cast<String>();
  }

  static Map<String, dynamic> get entries {
    assert(_box != null, 'call "prelude" first');
    return Map<String, dynamic>.from(_box!.toMap());
  }

  /// Get value by key.
  ///
  /// Return `fallback` if not found, or `null` if `fallback` is not provided.
  static T? get<T>(String key, [T? fallback]) {
    assert(_box != null, 'call "prelude" first');
    return _box!.get(key, defaultValue: fallback) as T?;
  }

  static Future<void> set(String key, dynamic value) {
    assert(_box != null, 'call "prelude" first');
    return _box!.put(key, value);
  }

  static Future<void> delete(String key) {
    assert(_box != null, 'call "prelude" first');
    return _box!.delete(key);
  }

  /// Apply patch to storage.
  ///
  /// It will do deletion first, then set items.
  static Future<void> patch({
    Iterable<String>? itemsToDelete,
    Map<String, dynamic>? itemsToSet,
  }) async {
    assert(_box != null, 'call "prelude" first');
    assert(itemsToSet != null || itemsToDelete != null, 'Nothing to patch.');

    if (itemsToDelete != null) await _box!.deleteAll(itemsToDelete);
    if (itemsToSet != null) await _box!.putAll(itemsToSet);
  }

  /// Removes all entries in the storage.
  static Future<void> clear() async {
    assert(_box != null, 'call "prelude" first');
    await _box!.clear();
  }

  /// Initialization.
  static Future<void> prelude() async {
    if (_box != null) {
      BadFl.log(
        module: 'impl/KVStorageImpl',
        message:
            'The call to "prelude" is ignored cause it has already been initialized',
      );
      return;
    }

    await Hive.initFlutter('kv_storage');
    _box = await Hive.openBox('@bad_fl');
    BadFl.log(module: 'impl/KVStorageImpl', message: 'Initialized');
  }
}
