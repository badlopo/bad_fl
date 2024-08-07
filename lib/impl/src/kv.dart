import 'package:hive_flutter/hive_flutter.dart';

/// `impl::kv`: key-value storage implementation
abstract class BadKV {
  static Box? _box;

  static void _guard() {
    if (_box == null) {
      throw StateError('The "prepare" must be called before any operation.');
    }
  }

  /// get value by key, return `fallback` if not found
  ///
  /// Throws an exception if
  /// - `prepare` is not called yet
  /// - `ValueType` is not matched
  static ValueType? get<ValueType>(String k, [ValueType? fallback]) {
    _guard();

    return _box!.get(k, defaultValue: fallback) as ValueType?;
  }

  /// set value by key
  ///
  /// Throws an exception if
  /// - `prepare` is not called yet
  static Future<void> set(String k, dynamic v) {
    _guard();

    return _box!.put(k, v);
  }

  /// remove value by key
  ///
  /// Throws an exception if
  /// - `prepare` is not called yet
  static Future<void> remove(String k) {
    _guard();

    return _box!.delete(k);
  }

  /// list all keys in storage
  static Iterable<String> keys() {
    _guard();

    return _box!.keys as Iterable<String>;
  }

  /// list all entries in storage
  static Map<String, dynamic> entries() {
    _guard();

    return Map<String, dynamic>.from(_box!.toMap());
  }

  /// remove some things and put some things
  static applyPatch({
    Iterable<String>? removeItems,
    Map<String, dynamic>? putItems,
  }) {
    _guard();

    if (removeItems != null) _box!.deleteAll(removeItems);
    if (putItems != null) _box!.putAll(putItems);
  }

  static Future<void> prepare(String subDir, String boxName) async {
    await Hive.initFlutter(subDir);
    _box = await Hive.openBox(boxName);
  }
}
