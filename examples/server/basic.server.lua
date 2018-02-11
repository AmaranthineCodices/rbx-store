local RbxStore = require(game.ReplicatedStorage.RbxStore)

local test = RbxStore.Store.new({
	state = {
		count = 0
	},
	mutations = {
		increment = function(payload, state)
			state.count = state.count + payload
		end
	}
})

print("basic", test.state.count)
test:commit("increment", 2)
print("basic", test.state.count)