cottages.furniture = {}

cottages.dofile("modules", "furniture", "api")
cottages.dofile("modules", "furniture", "nodes")
cottages.dofile("modules", "furniture", "crafts")

-- TODO: prevent multiple players from using the same bench/bed/mat simultaneously
-- TODO: detach the player if the bench/bed/mat is destroyed
-- TODO: detach the player if they try to jump or move
