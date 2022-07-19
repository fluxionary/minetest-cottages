for module, enabled in pairs(cottages.settings.enable) do
    if enabled then
        cottages.dofile("modules", module, "init")
    end
end
