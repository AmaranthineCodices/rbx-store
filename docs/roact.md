Rbx-store features built-in Roact integration. This API is almost identical to [Roact-Rodux](http://github.com/Roblox/roactrodux), so migrating components between the two should be (mostly) painless.

## Supplying the store
At the root of your Roact component hierarchy, insert a `RbxStore.RoactBridge.StoreProvider` component, like this:

```lua
local root = Roact.createElement(RbxStore.RoactBridge.StoreProvider, {
    store = -- ...your store here
}, {
    -- ... your original root element here
})
```

!!! note
    `StoreProvider` will error if more than one child is supplied.

`StoreProvider` uses Roact's context API to propagate your store through the entire component tree, where it can be used by connected components.

## Connecting components to the store
By default, components don't know that the store exists. They can't use it and they don't respond to it. To change this, you need to use `RbxStore.RoactBridge.connect`:

```lua
local function SomeComponent(props)
    return Roact.createElement("TextLabel", {
        Text = props.text,
        Size = UDim2.new(1, 0, 1, 0),
        Font = "SourceSans",
        -- ...
    })
end

local WrappedComponent = RbxStore.RoactBridge.connect(function(store)
    local state = store.state
    return {
        Text = state.someValue
    }
end)(SomeComponent)
```

Once you've wrapped the component, you can use it anywhere. It will re-render whenever the store's state changes and respond accordingly.
