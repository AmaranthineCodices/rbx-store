--[[

	Provides a link to Roact components, allowing Roact to be used with rbx-store.

]]

local Roact = require(script.Parent.Parent.Roact)

-- The key used when storing the store in context.
local storeKey = newproxy()

local function mergeTables(a, b)
	local new = {}

	for key, value in pairs(a) do
		new[key] = value
	end

	for key, value in pairs(b) do
		new[key] = value
	end

	return new
end

local RoactBridge = {}

RoactBridge.StoreProvider = Roact.Component:extend("RbxStoreStoreProvider")

function RoactBridge.StoreProvider:init(props)
	local store = props.store
	self._context[storeKey] = store
end

function RoactBridge.StoreProvider:render()
	return Roact.oneChild(self.props[Roact.Children])
end

function RoactBridge.connect(computeProps)
	return function(component)
		local wrappedComponent = Roact.Component:extend(("RbxStoreConnectionFor(%s)"):format(tostring(component)))

		function wrappedComponent:init()
			local store = self._context[storeKey]

			if not store then
				error("There is no store available (did you forget to wrap your root component in a RoactBridge.StoreProvider?)", 0)
			end

			self.store = store
			self.state = {
				propsFromStore = computeProps(store)
			}
		end

		function wrappedComponent:didMount()
			self.subscriptionHandle = self.store:subscribe(function()
				self:setState({
					propsFromStore = computeProps(self.store)
				})
			end)
		end

		function wrappedComponent:willUnmount()
			self.store:unsubscribe(self.subscriptionHandle)
		end

		function wrappedComponent:render()
			return Roact.createElement(component, mergeTables(self.props, self.state.propsFromStore))
		end

		return wrappedComponent
	end
end

return RoactBridge
