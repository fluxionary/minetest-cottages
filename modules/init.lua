for module, enabled in pairs(cottages.settings.enable) do
    if enabled then
        dofile(("%s/modules/%s/init.lua"):format(cottages.modpath, module))
    end
end
