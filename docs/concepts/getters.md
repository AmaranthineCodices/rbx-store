**Getters** allow you to compute values from the current state. They are accessed through a store's `get` method. Here's an example getter:

```lua
local function squareCounter(state)
    return state.value ^ 2
end
```

Getters are [memoized](https://en.wikipedia.org/wiki/Memoization) functions. The value they return is saved, and getting the value again returns the original value. This internal cache is reset when a mutation is committed.

!!! danger
    Because getters are memoized, they **must** be pure functions. This means that if the state is the same, the value the getter returns must also be the same. Here are some general things that getters should not do:

    * Call impure functions
    * Yield
    * Use any values that are not in the state

    An example of an impure getter, which uses the impure function `tick`, is below. This getter will return the same value, regardless of the time at which it was called, until a mutation is dispatched:
    
    ```lua
    local function badGetter(state)
        return tick() - state.startTick
    end
    ```

    For more information on pure functions, see [the Wikipedia page](https://en.wikipedia.org/wiki/Pure_function) on them.

    If a getter is not a pure function, it will be incorrectly cached. This **will** cause problems in your game!
