local dt = require "darktable"
local du = require "lib/dtutils"

du.check_min_api_version("2.0.0", "autocache")

-- script_manager integration to allow a script to be removed
-- without restarting darktable
local function destroy()
    -- nothing to destroy
end

dt.print("hello, world from autocache")

-- set the destroy routine so that script_manager can call it when
-- it's time to destroy the script and then return the data to
-- script_manager
local script_data = {}
script_data.destroy = destroy

return script_data
