The RoactBridge portion of rbx-store allows [Stores](./store.md) to drive [Roact](https://github.com/Roblox/roact) components. It is analogous to [Roact-Rodux](https://github.com/Roblox/roact-rodux) in terms of functionality. The API is designed to be identical as well.

See [Roact Usage](../roact.md) for examples and friendlier explanations.

## connect
```
function<Component><Component> connect(function<Store> computeProps)
```
Returns a function that wraps any component in a backed component. This component will re-render every time a mutation is dispatched by the root store.

## StoreProvider
StoreProvider is a Roact component that provides a store to all child components.

StoreProvider takes a single property: `store`. This must be a [Store](./store.md).

!!! note
    StoreProvider may have only one child. If more than one child is supplied, an error will be thrown.
