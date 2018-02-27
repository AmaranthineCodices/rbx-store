A **mutation** is an operation that changes the state. Mutations are the only way to change the state.

Mutations are simple functions. Here's an example:

```lua
local function mutate(payload, state)
    state.someValue = payload.value
end
```

Mutations can receive a payload, which can be any value. The mutation can use the payload's value when modifying the state.

Mutations have some special restrictions:

* They should not yield. This will slow down everything in the store. Mutations should be instantaneous; if you need to yield (invoking a RemoteFunction or interacting with a DataStore, for example), consider using an [action](actions.md) instead.
* They should not commit additional mutations. Mutations should only modify the state; they should do nothing else.
