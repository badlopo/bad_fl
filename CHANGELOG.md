## 0.4.3

> 2025.01.15

- Still WIP.

REFACTOR:

- Result (re-implement it due to weak inference of generics in dart)

## 0.4.2

> 2025.01.15

- Still WIP.

FIX:

- Result

## 0.4.1

> 2025.01.07

- Still WIP.

FIX:

- KVStorageImpl.prelude (make it static)

## 0.4.0

> 2024.12.30

- Still WIP.

ADD:

- BadTree widget.

## 0.3.0

> 2024.12.23

- Still WIP.

## 0.2.0

> 2024.11.05

- Add date in the changelog
- The project structure is about to change. This version is available for use in existing projects

## 0.1.0

Reorganized the entire project and renamed most of the classes (prefixed with bad).

- Everything can still be imported via `import 'package:bad_fl/bad_fl.dart'`
- Still not stable, so the major version is still `0`

## 0.0.3

BREAKING CHANGES:

- `BadWebviewFragment`:
    - renamed to `BadWebview`
    - moved to `prefab` collection
- `CacheImpl`: renamed to `FileCacheImpl`
    - `CacheImpl.remove`: renamed to `FileCacheImpl.delete`

NEW FEATURES:

- `BadBackToTop`: Implement the back-to-top logic (show and hide, scroll to the top) according to the
  passed `ScrollController`
- `BadFloating`: A wrapper that allows the components inside it to be dragged and placed anywhere on the screen
- `BadScrollAnchorScope`: A wrapper on top of `SingleChildScrollView`, allowing its child elements to act as anchors (be
  used as scroll target, listen to its show/hide state changes)
- `BadSignature`: A canvas component that can be used to make simple signatures
- `BadSnapshot`: A wrapper for capturing snapshot of its child widget

## 0.0.2

BUG FIXES:

- `BadTextInput`, `BadTextField`: Only dispose the internally maintained `TextEditingController` to avoid multiple
  dispose

DOCS:

- Updated README.md

OPTIMIZE:

- `BadOTPInput`, `BadPasswordInput`: remove unnecessary controller

## 0.0.1

- Initial version, created by lopo
