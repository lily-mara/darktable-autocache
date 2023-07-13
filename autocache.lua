local dt = require "darktable"
local du = require "lib/dtutils"

du.check_min_api_version("2.0.0", "autocache")

local function end_running_job()
    is_in_progress = false
    if not autocache_progress == nil then
        autocache_progress.valid = false
    end
end

-- script_manager integration to allow a script to be removed
-- without restarting darktable
local function destroy()
    dt.destroy_event('pre-import-autocache', 'pre-import')
    dt.destroy_event('post-import-image-autocache', 'post-import-image')
    end_running_job()
end

local image_count_current
local image_count_total
local autocache_progress
local is_in_progress

dt.register_event('pre-import-autocache', 'pre-import', function(_event, images)
    image_count_total = #images
    image_count_current = 0
    is_in_progress = true
    autocache_progress = dt.gui.create_job('Import autocache', true, end_running_job)
end)

dt.register_event('post-import-image-autocache', 'post-import-image', function(_event, image)
    if not is_in_progress then
        return
    end

    dt.control.dispatch(function()
        if not is_in_progress then
            return
        end

        image.generate_cache(image, true, 6, 6)

        image_count_current = image_count_current + 1

        autocache_progress.percent = (image_count_current / image_count_total) * 100

        if image_count_current == image_count_total then
            end_running_job()
        end
    end)
end)

-- set the destroy routine so that script_manager can call it when
-- it's time to destroy the script and then return the data to
-- script_manager
local script_data = {}
script_data.destroy = destroy

return script_data
