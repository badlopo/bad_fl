> **WARNING: THIS IS UNSTABLE UNTIL 1.x.x RELEASE**

## 0.10.0

> 2025.04.01

ADD:

- `BadSwitchAsync`: a switch update its state or do nothing according to result of task.

## 0.10.0

> 2025.04.01

- Still WIP.

REFACTOR:

- `BadButton`:
    - replace `centered` with `alignment`.
    - replace `tight` with `mainAxisSize`.

## 0.9.1

> 2025.03.21

- Still WIP.

FIX:

- `SearchKitMixin`: state machine transform error (from `Loading` to `Idle`)

## 0.9.0

> 2025.03.21

- Still WIP.

FEAT:

- `SearchKitMixin`: add `EndStrategy` to enable different `END` checker.

## 0.8.5

> 2025.03.12

- Still WIP.

FEAT:

- `IterableExt.separate`: add `groupSize` for grouping.

## 0.8.4

> 2025.03.05

- Still WIP.

FEAT:

- `BadInputXXX`: add `enabled` field.

## 0.8.3

> 2025.03.04

- Still WIP.

FEAT:

- `BadButton`: `BadButton.two` variant can be tight.

## 0.8.2

> 2025.03.03

- Still WIP.

FEAT:

- `BadButton`: add the `centered` property to determine whether `alignment: Alignment.center` is needed.

## 0.8.1

> 2025.03.02

- Still WIP.

ADD:

- `SetExt`: `toggle`.

FIX:

- `BadButton`: remove unnecessary `required` for `height`.

## 0.8.0

> 2025.02.27

- Still WIP.

ADD:

- `ImageIOImpl`: re-export `XFile`.
- `BadSpinner`: a wrapper that infinitely spin its child.

## 0.7.4

> 2025.02.24

- Still WIP.

BREAKING CHANGE:

- `BadButton`: rename `BadButton.lr` to `BadButton.two`.

## 0.7.3

> 2025.02.20

- Still WIP.

FIX:

- `BadSkeleton`: type check with `0` and `0.0`.

## 0.7.2

> 2025.02.20

- Still WIP.

ADD:

- `BadSkeleton`: skeleton block with shimmer effect.

## 0.7.1

> 2025.02.20

- Still WIP.

ADD:

- `BadButton`: add `lr` variant for two-child-row layout usage.

## 0.7.0

> 2025.02.14

- Still WIP.

ADD:

- `BadButtonAsync`: a button automatically switch child widget according to its state (`idle` or `pending`).

BREAKING CHANGE:

- `BadTree`: re-implement this widget. (now state can be cached in `TreeController`).

## 0.6.0

> 2025.02.14

- Still WIP.

ADD:

- `KVStorageImpl`: add `clear` for clear all items in k-v storage.

BREAKING CHANGE:

- `KVStorageImpl`: remove `directory` and `boxName` in `prelude`, use fixed names instead.
- `AppMetaImpl`: split `prelude` to `prelude` and `preludeAfterAgreed`.

## 0.5.4

> 2025.02.13

- Still WIP.

FIX:

- `KVStorageImpl`: type case.

## 0.5.3

> 2025.02.12

- Still WIP.

FIX:

- `BadInputController`: drop type check.

## 0.5.2

> 2025.02.12

- Still WIP.

FIX:

- `BadPopup`: some typo thing.

## 0.5.1

> 2025.02.12

- Still WIP.

REFACTOR:

- `BadPopup`: re-implement this widget.

## 0.5.0

> 2025.02.10

- Still WIP.

ADD:

- `BadNamedStack`: manage layers by name rather than index.
- `SSERawTransformer` & `SSEEventTransformer`: `StreamTransformer` for sse stream.

REFACTOR:

- rename `SnapshotScope` to `BadCapture`, add `captureAsPngBytes` for more convenient use.

## 0.4.4

> 2025.01.16

- Still WIP.

FIX:

- Result (incorrect 'isOk' in Result.err).

## 0.4.3

> 2025.01.15

- Still WIP.

REFACTOR:

- Result (re-implement it due to weak inference of generics in dart).

## 0.4.2

> 2025.01.15

- Still WIP.

FIX:

- Result: implementation.

## 0.4.1

> 2025.01.07

- Still WIP.

FIX:

- KVStorageImpl.prelude (make it static).

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

BREAKING CHANGE:

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
