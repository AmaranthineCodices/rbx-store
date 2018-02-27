Plugins let you augment a store's behavior. They can be specified when creating a store, or added on after the store has been created.

## Example
Plugins are functions that take one argument: a store. An example plugin is thus:

```lua
local function testPlugin(store)
    -- Called when the store is created

    store:subscribe(function(mutationName, payload)
        -- Called every time a mutation is committed
        print(("a mutation named %q was just committed!"):format(mutationName))
    end)
end
```

When creating a store, they are specified in the `plugins` key of the prototype object, like this:

```lua
local store = RbxStore.Store.new({
    plugins = { testPlugin }
})
```

When attaching a plugin to a store that's already been created, just call the plugin with the store, like this:

```lua
testPlugin(store)
```

## logger
Rbx-store ships with one plugin built-in: `logger`. It can be accessed as `RbxStore.logger`. This plugin logs every mutation, the payload, and the before/after state of the store.

!!! warning
    Because `logger` takes snapshots of the entire store's state, it can be very performance intensive. Do not use it in public versions of your game unless you absolutely must!
