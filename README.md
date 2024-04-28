# Bad FL

This project is an encapsulation of some common components and utils, aiming to decouple the project and improve
portability.

## Note

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