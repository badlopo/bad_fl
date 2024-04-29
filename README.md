# About BadFL

BadFL includes encapsulation of commonly used utils and components, as well as secondary encapsulation of commonly used
libraries (such as `dio`, `hive`, `device_info_plus`, etc.)

It expresses component properties in a form closer to CSS representation, making it easier for web developers to get
started.

**NOTICE!!!** This library **completely** abandons semantics! (For example, `Container`+`GestureDetector` is used to
express a `Button` rather than build-in ones) People who have related needs or care about this should use it with
caution.

# Architecture

## Extension

Extension methods of built-in types, named in the form of `<Type>Ext`.

### `ListExt`

- `slotted`: build a new element from each element of the list and insert slot elements between every two elements.

## Helper

// TODO

## Impl

// TODO

## Layout

// TODO

## Mixin

// TODO

## Prefab

// TODO

## Scaffold

// TODO

## Wrapper

// TODO

# Useful Tips

Some classes need to be initialized before use.

- `prepare`: can be called as soon as possible
- `extend`: may only be called after the privacy policy has been accepted

Below is a list of classes that need to be initialized:

| Class       | `prepare`                       | `extend`                       |
|-------------|---------------------------------|--------------------------------|
| `CacheImpl` | `static Future<bool> prepare()` | -                              |
| `MetaImpl`  | `static Future<bool> prepare()` | `static Future<bool> extend()` |

## Known issues

| Affected                     | Description                                                                                                                                 |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `TextInput`, `PasswordInput` | When all four edges of the border do not exist, using a non-zero borderRadius will cause unexpected lines to appear at the rounded corners. |