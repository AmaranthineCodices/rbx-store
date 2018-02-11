-- A plugin that logs all mutations committed to the store to the output.
-- This plugin takes snapshots of the store's state and as such has a fairly
-- significant performance hit, and should only be used in debug environments.

local indentStr = "    "

local function prettyPrint(t, indent)
	indent = indent or 1
	local outputBuffer = {
		"{\n"
	}

	for key, value in pairs(t) do
		local strKey = tostring(key)

		table.insert(outputBuffer, indentStr:rep(indent + 1))
		table.insert(outputBuffer, strKey)
		table.insert(outputBuffer, " = ")

		if type(value) == "table" then
			table.insert(outputBuffer, prettyPrint(value, indent + 1))
		else
			table.insert(outputBuffer, tostring(value))
			table.insert(outputBuffer, "; (")
			table.insert(outputBuffer, typeof(value))
			table.insert(outputBuffer, ")\n")
		end
	end

	table.insert(outputBuffer, indentStr:rep(indent))
	table.insert(outputBuffer, "}")

	return table.concat(outputBuffer, "")
end

return function(store)
	local previousState = store:snapshot()

	store:subscribe(function(mutationName, payload)
		local previousStateStr = prettyPrint(previousState)
		local newState = store:snapshot()
		local newStateStr = prettyPrint(newState)
		local payloadStr = typeof(payload) == "table" and prettyPrint(payload) or tostring(payload)

		print(("Mutation:\n    name: %q\n    payload: %s\n    previous state: %s\n    new state: %s"):format(
			mutationName,
			payloadStr,
			previousStateStr,
			newStateStr
		))

		previousState = newState
	end)
end