# Bad FL

This project is an encapsulation of some common components and utils, aiming to decouple the project and improve
portability.

## Note

Some classes need to be initialized before use, they have a static method named `prepare` to do this.

Below is a list of classes that need to be initialized:

| Class     | Description        |
|-----------|--------------------|
| CacheImpl | file cache manager |

## Known issues

| Affected                     | Description                                                                                                                                 |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `TextInput`, `PasswordInput` | When all four edges of the border do not exist, using a non-zero borderRadius will cause unexpected lines to appear at the rounded corners. |