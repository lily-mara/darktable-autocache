local dt = require "darktable"
local du = require "lib/dtutils"

du.check_min_api_version("2.0.0", "autocache")

-- script_manager integration to allow a script to be removed
-- without restarting darktable
local function destroy()
    -- nothing to destroy
end

local image_count_current
local image_count_total
local autocache_progress
local is_in_progress

dt.register_event('pre-import-autocache', 'pre-import', function(_event, images)
    image_count_total = #images
    image_count_current = 0
    is_in_progress = true
    autocache_progress = dt.gui.create_job('Import autocache', true, function()
        is_in_progress = false
        autocache_progress.valid = false
    end)
end)

-- set the destroy routine so that script_manager can call it when
-- it's time to destroy the script and then return the data to
-- script_manager
local script_data = {}
script_data.destroy = destroy

return script_data
