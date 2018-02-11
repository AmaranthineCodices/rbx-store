local RbxStore = require(game.ReplicatedStorage.RbxStore)

local test = RbxStore.Store.new({
	state = {
		count = 0
	},
	mutations = {
		increment = function(payload, state)
			state.count = state.count + payload
		end
	},
	getters = {
		square = function(store)
			return store.state.count ^ 2
		end,
	}
})

test:commit("increment", 2)
print("getter", test:get("square"))