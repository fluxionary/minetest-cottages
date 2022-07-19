-- search for the workbench in AdventureTest
local workbench = minetest.registered_nodes["workbench:3x3"]
if workbench then
	cottages_table_def.tiles = {workbench.tiles[1], cottages_table_def.tiles[1]}
	cottages_table_def.on_rightclick = workbench.on_rightclick
end
-- search for the workbench from RealTEst
workbench = minetest.registered_nodes["workbench:work_bench_birch"]
if workbench then
	cottages_table_def.tiles = {workbench.tiles[1], cottages_table_def.tiles[1]}
	cottages_table_def.on_construct = workbench.on_construct
	cottages_table_def.can_dig = workbench.can_dig
	cottages_table_def.on_metadata_inventory_take = workbench.on_metadata_inventory_take
	cottages_table_def.on_metadata_inventory_move = workbench.on_metadata_inventory_move
	cottages_table_def.on_metadata_inventory_put = workbench.on_metadata_inventory_put
end
