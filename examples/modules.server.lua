local RbxStore = require(game.ReplicatedStorage.RbxStore)

local root = RbxStore.Store.new({
	modules = {
		counter = RbxStore.Store.new({
			state = { value = 0 },
			mutations = {
				increment = function(payload, state)
					state.value = state.value + payload
				end
			}
		}),
		other = RbxStore.Store.new({
			state = { message = nil },
			mutations = {
				changeMessage = function(payload, state)
					state.message = payload
				end
			}
		})
	}
})

print("modules", root.state.counter.value)
print("modules", root.state.other.message)

root:commit("other/changeMessage", "test message")

print("modules", root.state.other.message)

root:commit("counter/increment", 100)

print("modules", root.state.counter.value)