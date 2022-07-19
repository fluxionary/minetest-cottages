function cottages.anvil.make_unrepairable(itemstring)
    local def = minetest.registered_items[itemstring]
    local groups = table.copy(def.groups or {})
    groups.not_repaired_by_anvil = 1
    minetest.override_item(itemstring, {groups = groups})
end

if minetest.get_modpath("technic") then
    -- make rechargeable technic tools unrepairable`
    cottages.anvil.make_unrepairable("technic:water_can")
    cottages.anvil.make_unrepairable("technic:lava_can")
    cottages.anvil.make_unrepairable("technic:flashlight")
    cottages.anvil.make_unrepairable("technic:battery")
    cottages.anvil.make_unrepairable("technic:vacuum")
    cottages.anvil.make_unrepairable("technic:prospector")
    cottages.anvil.make_unrepairable("technic:sonic_screwdriver")
    cottages.anvil.make_unrepairable("technic:chainsaw")
    cottages.anvil.make_unrepairable("technic:laser_mk1")
    cottages.anvil.make_unrepairable("technic:laser_mk2")
    cottages.anvil.make_unrepairable("technic:laser_mk3")
    cottages.anvil.make_unrepairable("technic:mining_drill")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk2")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk2_1")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk2_2")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk2_3")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk2_4")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk3")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk3_1")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk3_2")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk3_3")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk3_4")
    cottages.anvil.make_unrepairable("technic:mining_drill_mk3_5")
end
