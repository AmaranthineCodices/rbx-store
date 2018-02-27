**Actions** are asynchronous tasks that commit mutations. They are dispatched to a store using its `dispatch` method. A good example of an action is one that invokes a RemoteFunction on the client and commits a mutation to the store based on what it gets from the server.

Here's a stub action:
```lua
local function someAction(payload, store)
    local returnValue = remoteFunction:InvokeServer(payload)
    store:commit("someMutation", returnValue)
end
```

Actions should never change the state of the store directly. They should commit mutations that change the state for them instead.

Like mutations, actions can receive a payload.

## Example
Here's an example of an action in use:
```lua
-- On the server.
-- Remote is a RemoteFunction.
local remote = game:GetService("ReplicatedStorage").Remote

remote.OnServerInvoke = function(player)
    return math.random()
end
```

```lua
-- On the client.
local remote = game:GetService("ReplicatedStorage").Remote

local store = RbxStore.Store.new({
    state = {
        serverValue = nil
    },
    mutations = {
        setServerValue = function(payload, state)
            state.serverValue = payload
        end,
    },
    actions = {
        getFromServer = function(store)
            local serverValue = remote:InvokeServer()
            store:commit("setServerValue", serverValue)
        end,
    }
})

store:dispatch("getFromServer")
```
