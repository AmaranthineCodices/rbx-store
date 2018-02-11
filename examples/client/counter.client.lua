local RbxStore = require(game.ReplicatedStorage.RbxStore)
local Roact = require(game.ReplicatedStorage.Roact)
local e = Roact.createElement

local store = RbxStore.Store.new({
	state = {
		count = 0
	},
	mutations = {
		increment = function(payload, state)
			state.count = state.count + payload
		end
	}
})

local counter = RbxStore.RoactBridge.connect(function(store)
	return {
		count = store.state.count
	}
end, function(props)
	return e("TextButton", {
		Text = ("%d\nincrement"):format(props.count),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 100, 0, 80),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Font = "SourceSansBold",
		TextSize = 20,

		[Roact.Event.MouseButton1Click] = function()
			store:commit("increment", 1)
		end
	})
end)

local tree = e("ScreenGui", {
	ZIndexBehavior = "Sibling",
}, {
	e(RbxStore.RoactBridge.StoreProvider, { store = store }, {
		e(counter)
	})
})

Roact.reify(tree, game.Players.LocalPlayer:WaitForChild("PlayerGui"))