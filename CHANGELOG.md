## [1.0.0] - Initial release

* Redux implementation for Dart with Workers.
* :3

## [1.0.0+1, 1.0.0+2] - Fixes

* Fixed variable naming prior to dart linter

## [1.0.1] - Flutter renovations! :D

* Merged WidgetStoreProviderMixin and StoreProvider together
* Removed redundant cache implementation

## [1.0.2] - Store hooks

* Added store hooks

## [1.0.3, 1.0.3+1, 1.0.3+2, 1.0.3+3] - Bug fixes

* Fixed a bug, where the first build of `StoreState` gets null in `getState()`
* Fixed a bug with type infer of `StoreHook`
* Updated dependencies

## [1.0.4] - get the state right now!

* Added a way to get current state in store without awaiting

## [1.0.5] - stay new!

* Fixed `StoreState` getting older or even initialState when calling `build` first time

## [1.1.0] - state changes out of StoreState

* Removed null checks in tests (deprecated in `1.0.5`)
* Updated credits and docs
* Added `StoreBuilder`: a widget that hooks to Store channel and listens to changes out of StoreState