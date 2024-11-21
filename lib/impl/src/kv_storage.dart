import 'package:hive_ce_flutter/adapters.dart';

/// Key-Value storage implementation.
abstract class KVStorageImpl {
  /// Hive box instance.
  static late final Box _box;

  static Iterable<String> get keys => _box.keys as Iterable<String>;

  // TODO: test if 'as' works, or we need to use 'cast'
  static Map<String, dynamic> get entries =>
      _box.toMap() as Map<String, dynamic>;

  /// Get value by key.
  ///
  /// Return `fallback` if not found, or `null` if `fallback` is not provided.
  static T? get<T>(String key, [T? fallback]) {
    return _box.get(key, defaultValue: fallback) as T?;
  }

  static Future<void> set(String key, dynamic value) {
    return _box.put(key, value);
  }

  static Future<void> delete(String key) {
    return _box.delete(key);
  }

  /// Apply patch to storage.
  ///
  /// It will do deletion first, then set items.
  static Future<void> patch({
    Iterable<String>? itemsToDelete,
    Map<String, dynamic>? itemsToSet,
  }) async {
    assert(itemsToSet != null || itemsToDelete != null, 'Nothing to patch.');

    if (itemsToDelete != null) await _box.deleteAll(itemsToDelete);
    if (itemsToSet != null) await _box.putAll(itemsToSet);
  }

  /// Do prelude before available.
  Future<void> prelude(String directory, String boxName) async {
    await Hive.initFlutter(directory);
    _box = await Hive.openBox(boxName);
  }
}
