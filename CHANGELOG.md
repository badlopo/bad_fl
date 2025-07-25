> **WARNING: THIS IS UNSTABLE UNTIL 1.x.x RELEASE**

## 1.0.0

🎉 INTRODUCING 1.0.0!

### Experimental

The items under this module are experimental and will ensure basic normal use but may change at any time.

- `BadNamedStack`: Completely rewritten! Now it provides parameters and usage similar to `IndexedStack` (no longer using
  `NamedStackController`).

### Extensions

- `IterableExt`:
    - `enumerate`: REMOVED! Since there is already a built-in getter `indexed` that does exactly the same thing.
    - `zip`: Introducing new extension methods on `Iterable`.

### Impl (deprecated)

Most of the content under this module has been deleted (because it can be better encapsulated directly based on the
third-party packages it uses).

- `TextMeasureImpl`: moved to the `utils` module
- `FileStorageImpl`: moved to the `kit` module

### Utils

- `helper`: Here are some helper functions for data conversion, such as `asIs`, `nonNull`(new), `separate`(new).
- `measureText`: Previously `TextMeasureImpl.measure`, now classified as a utility function.
- `Result`: Use `as` instead of null check operator `!` to enable nullable generics.

### Widgets

- `BadAnchoredScrollable`: Completely rewritten! Now the anchor information is stored in `BadAnchoredScrollable` instead
  of its controller, which allows you to use one controller to control as many different lists as you want.
    - Now you can control multiple lists with the same `BadAnchoredScrollableController`.
    - Now `null` can also be used as an anchor value.
    - Silently ignore attempts to jump to nonexistent anchors (previously would have resulted in an error).
- `BadButton`: Completely rewritten! Now the button will always be a `StatefulWidget`.
    - The logic of `BadButtonAsync` has been merged, `onPressed` now accepts a function that returns a `FutureOr`, and
      the button will show the `loadingWidget` during its execution.
    - Rename `BadButton.two` to `BadButton.icon`, which is more semantically correct.
- `BadExpandable`:
    - Rename to `BadExpansible`.
    - Re-implement the way it works.
- `BadPopup`:
    - Re-implement show and hide. Now you can use one controller to control multiple components. (something like `spmc`)
    - Remove `rebuildOnVisible`, add it later if necessary.
    - Do some renaming on its properties.
- `BadSwitch`: Completely rewritten! Now the button will always be a `StatefulWidget`.
    - Custom loading widgets are no longer supported, always use `Icons.autorenew_rounded` (this allows for better size
      control, of course this can also be achieved using `FittedBox`).
    - Simplified `padding` to `insets`, now the padding on all four sides is always the same.
    - rename `onTap` to `onWillChange`, now it is more intuitive and supports async handler and cancellation.
- `BadTree`:
    - The tree control logic and rendering logic are now completely decoupled. You can use `BadTreeController` only and
      implement your own renderer as needed.
    - Now a `BadTreeController` can be attached to multiple `BadTree` widget to achieve the effect of multiple views
      sharing state and linkage.

---

## 0.13.3

> 2025.05.28

FIX:

- `BadPopup`: log condition ...

## 0.13.2

> 2025.05.28

FIX:

- `BadPopup`: correct lifecycle handlers and add some log info.

## 0.13.1

> 2025.04.09

FIX:

- `SearchKitMixin`: remove `protected` decorator on `unsafeMutate`.

## 0.13.0

> 2025.04.08

FEAT:

- `SearchKitMixin`: add `unsafeMutate` for custom mutation.

REFACTOR:

- `SearchKitMixin`: make `searchTarget` generic for more flexible usage.

## 0.12.1

> 2025.04.07

FIX:

- `BadButtonAsync`: remove unnecessary `required` for `height`.

## 0.12.0

> 2025.04.07

ADD:

- `ScrollControllerExt`: `clampInExtent`.

## 0.11.0

> 2025.04.01

ADD:

- `BadSwitchAsync`: a switch update its state or do nothing according to result of task.

## 0.10.0

> 2025.04.01

REFACTOR:

- `BadButton`:
    - replace `centered` with `alignment`.
    - replace `tight` with `mainAxisSize`.

## 0.9.1

> 2025.03.21

FIX:

- `SearchKitMixin`: state machine transform error (from `Loading` to `Idle`)

## 0.9.0

> 2025.03.21

FEAT:

- `SearchKitMixin`: add `EndStrategy` to enable different `END` checker.

## 0.8.5

> 2025.03.12

FEAT:

- `IterableExt.separate`: add `groupSize` for grouping.

## 0.8.4

> 2025.03.05

FEAT:

- `BadInputXXX`: add `enabled` field.

## 0.8.3

> 2025.03.04

FEAT:

- `BadButton`: `BadButton.two` variant can be tight.

## 0.8.2

> 2025.03.03

FEAT:

- `BadButton`: add the `centered` property to determine whether `alignment: Alignment.center` is needed.

## 0.8.1

> 2025.03.02

ADD:

- `SetExt`: `toggle`.

FIX:

- `BadButton`: remove unnecessary `required` for `height`.

## 0.8.0

> 2025.02.27

ADD:

- `ImageIOImpl`: re-export `XFile`.
- `BadSpinner`: a wrapper that infinitely spin its child.

## 0.7.4

> 2025.02.24

BREAKING CHANGE:

- `BadButton`: rename `BadButton.lr` to `BadButton.two`.

## 0.7.3

> 2025.02.20

FIX:

- `BadSkeleton`: type check with `0` and `0.0`.

## 0.7.2

> 2025.02.20

ADD:

- `BadSkeleton`: skeleton block with shimmer effect.

## 0.7.1

> 2025.02.20

ADD:

- `BadButton`: add `lr` variant for two-child-row layout usage.

## 0.7.0

> 2025.02.14

ADD:

- `BadButtonAsync`: a button automatically switch child widget according to its state (`idle` or `pending`).

BREAKING CHANGE:

- `BadTree`: re-implement this widget. (now state can be cached in `TreeController`).

## 0.6.0

> 2025.02.14

ADD:

- `KVStorageImpl`: add `clear` for clear all items in k-v storage.

BREAKING CHANGE:

- `KVStorageImpl`: remove `directory` and `boxName` in `prelude`, use fixed names instead.
- `AppMetaImpl`: split `prelude` to `prelude` and `preludeAfterAgreed`.

## 0.5.4

> 2025.02.13

FIX:

- `KVStorageImpl`: type case.

## 0.5.3

> 2025.02.12

FIX:

- `BadInputController`: drop type check.

## 0.5.2

> 2025.02.12

FIX:

- `BadPopup`: some typo thing.

## 0.5.1

> 2025.02.12

REFACTOR:

- `BadPopup`: re-implement this widget.

## 0.5.0

> 2025.02.10

ADD:

- `BadNamedStack`: manage layers by name rather than index.
- `SSERawTransformer` & `SSEEventTransformer`: `StreamTransformer` for sse stream.

REFACTOR:

- rename `SnapshotScope` to `BadCapture`, add `captureAsPngBytes` for more convenient use.

## 0.4.4

> 2025.01.16

FIX:

- Result (incorrect 'isOk' in Result.err).

## 0.4.3

> 2025.01.15

REFACTOR:

- Result (re-implement it due to weak inference of generics in dart).

## 0.4.2

> 2025.01.15

FIX:

- Result: implementation.

## 0.4.1

> 2025.01.07

FIX:

- KVStorageImpl.prelude (make it static).

## 0.4.0

> 2024.12.30

ADD:

- BadTree widget.

## 0.3.0

> 2024.12.23

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
