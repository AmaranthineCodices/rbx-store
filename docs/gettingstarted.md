The goal of rbx-store is to allow you to manage your game's state in one centralized location. It's inspired by several projects in the JavaScript ecosystem, where centralized state management has become a popular tool. rbx-store is designed to mimic [Vuex](https://github.com/vuejs/vuex), and most of the practices around that ecosystem apply here.

## Installation
To get started with rbx-store, you'll need to install it. There are two ways to do this:

1. Use the installer from the [latest release](https://github.com/AmaranthineCodices/rbx-store/releases). Run it using the "Run Script" button in the Test tab of Roblox Studio.
2. Clone the repository and use a tool like [Rojo](https://github.com/LPGhatguy/rojo) to sync it into your game.

In either case, you will need to install [PropTypes](https://github.com/AmaranthineCodices/rbx-prop-types/). Place it in the same location you installed rbx-store in.

If you want to use [Roact](https://github.com/Roblox/roact) with rbx-store, you'll need to install it in the same location as rbx-store. This will automatically enable rbx-store's Roact integration.

## A simple store
Here's a super-basic store example:

```lua
local store = RbxStore.Store.new({
    state = {
        counter = 0,
    },
    mutations = {
        increment = function(payload, state)
            state.counter = state.counter + (payload or 1)
        end,
    },
})

print(store.state.counter)
--> 0

store:commit("increment")
print(store.state.counter)
--> 1

store:commit("increment", 2)
print(store.state.counter)
--> 3
```

!!! note
    In all the examples in this documentation, rbx-store has already been required as `RbxStore`.
