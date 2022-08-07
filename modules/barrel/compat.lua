local api = cottages.barrel

if cottages.has.bucket then
	api.register_barrel_liquid({
		liquid = "default:water_source",
		bucket_empty = "bucket:bucket_empty",
		bucket_full = "bucket:bucket_water",
	})
	api.register_barrel_liquid({
		liquid = "default:river_water_source",
		bucket_empty = "bucket:bucket_empty",
		bucket_full = "bucket:bucket_river_water",
	})
	api.register_barrel_liquid({
		liquid = "default:lava_source",
		bucket_empty = "bucket:bucket_empty",
		bucket_full = "bucket:bucket_lava",
	})
end
