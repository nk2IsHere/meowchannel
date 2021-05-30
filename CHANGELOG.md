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

## [1.1.0, 1.1.0+0] - state changes out of StoreState

* Removed null checks in tests (deprecated in `1.0.5`)
* Updated credits and docs
* Added `StoreBuilder`: a widget that hooks to Store channel and listens to changes out of StoreState

## [1.2.0] - dispatcher goes async
* `Dispatcher` now will act as an async function\
 (basically blocking old-flavoured `Dispatcher` is now wrapped into async beauty)
* THIS IS A BREAKING CHANGE:\
  all blocking Reducers must be wrapped in `syncedReducer`\
  all workers must `await` any action put in context in order to ensure that it is posted\
  all middlewares must return `Future<void>`

## [1.2.1, 1.2.1+0] - fix StoreState
* fix StoreState putting actions called on `dispose()` to `setState()`
* fix example

## [1.3.3, 1.3.3+0]

* fix StoreRepeater

## [1.3.4, 1.3.4+0]

* add computeN function to extensions.worker
* add initialize function
* bump rxdart version

## [1.4.0]

* fix `WorkerContext` compute* functions
* add `computedModule`: vue-like extensions.computed variables accessible on build
* add `storeLoggerModule`
* migrate `Middleware` -> `Module`

## [1.4.1]

* export extensions.computed from library
* generify StateChannel

## [1.4.2]

* fix store logger

## [1.4.3]

* fix computedmixin's actions affecting storehooks
* add previous state storehook

## [1.4.4]

* fix storestate mixinglobalhooks

## [2.0.0]

* migrate to null-safety
* minor refactor
