# Bad FL

This project is an encapsulation of some common components and utils, aiming to decouple the project and improve
portability.

## Known issues

| Affected                     | Description                                                                                                                                 |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `TextInput`, `PasswordInput` | When all four edges of the border do not exist, using a non-zero borderRadius will cause unexpected lines to appear at the rounded corners. |