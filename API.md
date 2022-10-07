# anvil

* `cottages.anvil.make_unrepairable(itemstring)`
  makes the item unrepairable in the anvil
* `cottages.anvil.can_repair(item_or_stack)`
  returns true/false

# barrel

* `cottages.barrel.register_barrel_liquid(def)`
  ```lua
  def = {
      liquid = "default:water_source",
      liquid_name = S("Water"),
      liquid_texture = "default_water.png",
      liquid_input_sound = cottages.sounds.water_empty,
      liquid_output_sound = cottages.sounds.water_fill,
      bucket_empty = "bucket:bucket_empty",
      bucket_full = "bucket:bucket_water",
  }
  ```
# doorlike

* `api.register_hatch(nodename, description, texture, receipe_item, def)`

# feldweg

* `api.register_feldweg(node, def)`

# roof

* `cottages.roof.register_roof(name, material, tiles)`

# straw

* `api.register_quern_craft(recipe)`
* `api.register_threshing_craft(recipe)`
