Compartmentalizing your code is an important part of writing clean, maintainable code. rbx-store allows you to modularize your state management using **modules**. Modules are simply stores that are "children" of your root store.

Here's an example:

```lua
local rootStore = RbxStore.Store.new({
    modules = {
        counter = RbxStore.Store.new({
            state = {
                value = 0
            },
            mutations = {
                increment = function(payload, state)
                    state.value = state.value + (payload or 1)
                end
            },
        }),
        todos = RbxStore.Store.new({
            state = {
                todos = {},
            },
            mutations = {
                addTodo = function(payload, state)
                    state.todos[payload.name] = false
                end,
                completeTodos = function(payload, state)
                    state.todos[payload.name] = true
                end,
            },
            getters = {
                unfinishedTodos = function(state)
                    local unfinished = {}

                    for todo, completed in pairs(state.todos) do
                        if not completed then
                            table.insert(unfinished, todo)
                        end
                    end

                    return unfinished
                end
            }
        })
    }
})
```

Here, the root store, `rootStore`, is created with two child modules: `counter` and `todos`. The state of these children is added to the root store's state under the name of the module. To access the state of the `counter` module, for example:

```lua
print(rootStore.state.counter.value)
--> 0
```

To commit a mutation on a module, use the path to the module, separated by `/` characters, followed by the path to the mutation. This will work for grandchildren as well - you can nest modules as deep as you need to.

Here's an example of committing the `counter` module's `increment` mutation:
```lua
rootStore:commit("counter/increment")
print(rootStore.state.counter.value)
--> 1
```

The same method can be used for actions and getters of modules. For example, to get all the unfinished todos in `todos`:
```lua
rootStore:get("todos/unfinishedTodos")
```
