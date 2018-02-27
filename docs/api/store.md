The `Store` class is the central part of rbx-store. It can be accessed under the name `Store` from the root rbx-store module. If `RbxStore` is the imported name of the rbx-store module, for example, `Store` is accessed as `RbxStore.Store`.

## Store.new
```
Store Store.new(prototype)
```
Creates a new store from a prototype table.

`prototype` is a table describing the behavior of the store. The following keys are supported:

* `state` (table): the initial state of the store.
* `mutations` (table): a table of mutations that may be performed on the state. Mutations should be functions; for more information see [mutations](../concepts/mutations).
* `actions` (table): a table of actions that the store can perform. Actions should be functions; for more information see [actions](../concepts/actions).
* `getters` (table): a table of values that can be computed from the store's state. Getters should be pure functions; for more information see [getters](../concepts/getters).
* `modules` (table): a table of child stores. All members of this table must be stores; for more information see [modules](../concepts/modules).
* `plugins` (table): a table of plugins. When the store is created, each plugin will be called. All plugins should be functions; for more information see [plugins](../concepts/plugins).

This function will throw an error if any of the keys in `prototype` are malformed or an unused key is present.

!!! warning
    If `state` is specified, **it may only be used once**. The state table passed in the prototype is used directly as the store's state table. Reusing the table will cause bizarre issues.

## commit
```
void Store:commit(string mutationName, Variant payload)
```
Invokes the mutation named `mutationName` on the store, passing `payload` to it.

To invoke mutations of modules, use the mutation name `module/mutationName` from the root store.

## dispatch
```
void Store:dispatch(string actionName, Variant payload)
```
Dispatches the action named `actionName` on the store, passing `payload` to it.

To invoke actions of modules, use the action name `module/actionName` from the root store.

## get
```
void Store:get(string getterName)
```
Gets the computed property named `getterName` and returns the value.

To get computed properties of modules, use the name `module/getterName` from the root store.

The value of getters is cached until the next mutation is committed.

## snapshot
```
table Store:snapshot()
```
Returns a snapshot of the store's state at the time of invocation. This function can be performance intensive; do not use it excessively.

## subscribe
```
userdata Store:subscribe(function subscriber)
```
Subscribes a function to the store. `subscriber` will be invoked *asynchronously* whenever a mutation is committed, and will receive the mutation name and payload.

This function returns a userdata handle that may be passed to `unsubscribe` to unsubscribe from the function.

!!! warning
    The type of the handle that this function returns is not guaranteed to be `userdata`. Do not perform inspection of this value; its sole purpose is to be a unique value.

## unsubscribe
```
void Store:unsubscribe(userdata handle)
```
Unsubscribes a function using the handle returned from `subscribe`. This function does nothing if `handle` is invalid or the function has already been unsubscribed.
