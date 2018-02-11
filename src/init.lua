-- The main module.
-- This is the only thing that should be required; you should never need to require any other module.

local lib = {}

lib.Store = require(script.Store)
lib.logger = require(script.loggerPlugin)

return lib