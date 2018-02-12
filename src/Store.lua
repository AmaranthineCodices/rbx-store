local PropTypes = require(script.Parent.Parent.PropTypes)

local Store = {}
Store.class = Store
Store.__index = Store

local storePropTypes = {
	state = PropTypes.table.optional,
	mutations = PropTypes.tableOf(PropTypes.func),
	getters = PropTypes.tableOf(PropTypes.func).optional,
	actions = PropTypes.tableOf(PropTypes.func).optional,
	modules = PropTypes.tableOf(PropTypes.matchesAll(
		PropTypes.table,
		function(value)
			return value.class == Store, "value was not a Store"
		end
	)),
	plugins = PropTypes.tableOf(PropTypes.func),
}

local function deepCopy(original)
	local copy = {}

	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = deepCopy(value)
		else
			copy[key] = value
		end
	end

	return copy
end

function Store.new(props)
	assert(PropTypes.validate(props, storePropTypes, { strict = true }))

	local self = setmetatable({
		state = props.state or {},
		mutations = props.mutations or {},
		getters = props.getters or {},
		actions = props.actions or {},
		modules = props.modules or {},
		_getterCache = {},
		_subscribers = {},
	}, Store)

	-- Sanity check all the getter/action/mutation/module keys.
	-- Each one must not contain the `/` character.
	for _, list in ipairs({ self.mutations, self.getters, self.actions, self.modules }) do
		for key, _ in pairs(list) do
			if key:find("/") ~= nil then
				error(("The key %q is invalid: cannot contain a `/` character."):format(tostring(key)), 0)
			end
		end
	end

	-- Copy the states of all modules to the state table.
	-- State is always a reference so this will work.
	for key, module in pairs(self.modules) do
		self.state[key] = module.state
	end

	-- Hook in all plugins.
	if props.plugins then
		for _, plugin in ipairs(props.plugins) do
			plugin(self)
		end
	end

	return self
end

--[[

	Commits a mutation.
	Mutations alter the store's state. This has the following additional effects:
	* The internal getter cache is cleared.
	* All subscribers are invoked.

	This function will throw if `mutationName` does not correspond to a mutation
	in the store's own mutations table or to a mutation in a child store.

]]
function Store:commit(mutationName, payload)
	-- Do we have a direct match for the mutator?
	local mutator = self.mutations[mutationName]

	-- If so, use it.
	if mutator then
		-- Nuke the getter cache.
		for key, _ in pairs(self._getterCache) do
			self._getterCache[key] = nil
		end

		-- State will be mutated; pass-by-ref.
		mutator(payload, self.state)

		-- Invoke all subscribers asynchronously.
		for _, subscriber in pairs(self._subscribers) do
			spawn(function()
				subscriber(mutationName, payload)
			end)
		end
	-- If it contains a / character it's targeting a module.
	elseif mutationName:match("/") then
		-- Modules are Stores themselves. We only care about the module name; the module will deal with the rest.
		local moduleName, remainder = mutationName:match("^([^/]+)/(.+)")
		local module = self.modules[moduleName]

		if module then
			module:commit(remainder, payload)
		else
			error(("No module %q in this Store"):format(moduleName), 0)
		end
	else
		error(("Could not commit a mutation of name %q: there is no mutator function."):format(mutationName), 0)
	end
end

--[[

	Dispatches an action.
	Actions perform arbitrary asynchronous actions and interact with the store by
	committing mutations at arbitrary timeframes.

	Actions are invoked asynchronously.

	This function will throw if `actionName` does not correspond to an action in
	either the store's internal action table or an action in a child store.

]]
function Store:dispatch(actionName, payload)
	-- Do we have a direct match for the action handler?
	local action = self.actions[actionName]

	-- If so, use it.
	if action then
		-- Do it asynchronously.
		spawn(function()
			-- For simplicity, just pass the store to it.
			-- In the future this should really just be a `commit` function, but whatever.
			action(self, payload)
		end)
	-- If it contains a / character it's targeting a module.
	elseif actionName:match("/") then
		-- Modules are Stores themselves. We only care about the module name; the module will deal with the rest.
		local moduleName, remainder = actionName:match("^([^/]+)/(.+)")
		local module = self.modules[moduleName]

		if module then
			module:dispatch(remainder, payload)
		else
			error(("No module %q in this Store"):format(moduleName), 0)
		end
	else
		error(("Could not dispatch an action of name %q: there is no handler."):format(actionName), 0)
	end
end

--[[

	Invokes a getter. Getters are memoized and should be pure functions.
	This memoization is invalidated when the Store's state changes.

]]
function Store:get(getterName)
	-- Do we have a direct match for the getter?
	local getter = self.getters[getterName]

	-- If so, use it.
	if getter then
		-- Have we cached a value for the getter?
		if self._getterCache[getterName] ~= nil then
			-- If we have, then use it.
			return self._getterCache[getterName]
		-- Otherwise, don't bother.
		else
			return getter(self)
		end
	-- If it contains a / character it's targeting a module.
	elseif getterName:match("/") then
		-- Modules are Stores themselves. We only care about the module name; the module will deal with the rest.
		local moduleName, remainder = getterName:match("^([^/]+)/(.+)")
		local module = self.modules[moduleName]

		if module then
			return module:get(remainder)
		else
			error(("No module %q in this Store"):format(moduleName), 0)
		end
	else
		error(("Could not use getter of name %q: does not exist."):format(getterName), 0)
	end
end

--[[

	Takes a deep copy of the entire state table.

]]
function Store:snapshot()
	return deepCopy(self.state)
end

function Store:_subscribeInternal(subscriber, handle)
	self._subscribers[handle] = subscriber
end

--[[

	Subscribes to changes to the store.
	`subscriber` will  be invoked every time a mutation is committed.
	It will receive a mutation type as the first argument, equivalent
	to the mutation name passed to commit(). It will also receive the
	mutation's payload. It will not receive a reference to the state
	of the Store.

	This function returns a handle that can be used to unsubscribe
	from the store with unsubscribe().

]]
function Store:subscribe(subscriber)
	local handle = newproxy()
	self:_subscribeInternal(subscriber, handle)

	-- For every child module, we also need to subscribe there.
	for _, module in pairs(self.modules) do
		module:_subscribeInternal(subscriber, handle)
	end

	return handle
end

--[[

	Unsubscribes a function from the store using the handle returned
	by subscribe().

]]
function Store:unsubscribe(handle)
	self._subscribers[handle] = nil
end

return Store
