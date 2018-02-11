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
	plugins = { RbxStore.logger }
})

test:commit("increment", 2)