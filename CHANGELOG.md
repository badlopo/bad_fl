## 0.0.4

BREAKING CHANGES:

- `ListExt`: now `IterableExt` to support more flex usage

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
