require("scripts.util.parse-table");

---@class CustomPrototype
---@field type string The type of the prototype.
---@field name string The name of the prototype.

---@class IntermodalLogisticsGame
---Properties:
---@field gantries GantryPrototype[]
---@field docks DockPrototype[]
---@field containers ContainerPrototype[]
---@field container_wagons ContainerWagonPrototype[]
---@field container_ships ContainerShipPrototype[]
---@field prototype_map {[string]: CustomPrototype}
---@field associated_prototype_map {[string]: CustomPrototype}

---Constructor for an IntermodalLogisticsGame.
---@param intermodal_logistics_pipeline IntermodalLogisticsPipeline The pipeline data.
---@return IntermodalLogisticsGame # The constructed mod game script.
function make_intermodal_logistics_game(intermodal_logistics_pipeline)
	---@type IntermodalLogisticsGame
	local intermodal_logistics_game = {
		-- Arrays.
		gantries = table.deepcopy(intermodal_logistics_pipeline.gantries),
		docks = table.deepcopy(intermodal_logistics_pipeline.docks),
		containers = table.deepcopy(intermodal_logistics_pipeline.containers),
		container_wagons = table.deepcopy(intermodal_logistics_pipeline.container_wagons),
		container_ships = table.deepcopy(intermodal_logistics_pipeline.container_ships),
		-- Lookup tables.
		prototype_map = {},
		placement_handled = {},
	};

	for _, gantry in pairs(intermodal_logistics_game.gantries) do
		gantry.type = "gantry";
		intermodal_logistics_game.prototype_map[gantry.name] = gantry;

		--Dummy
		intermodal_logistics_game.associated_prototype_map[gantry.placement_dummy_prototype] = gantry;
		--Rotations
		intermodal_logistics_game.associated_prototype_map[gantry.rotations.north.prototype] = gantry;
		intermodal_logistics_game.associated_prototype_map[gantry.rotations.east.prototype] = gantry;
		intermodal_logistics_game.associated_prototype_map[gantry.rotations.south.prototype] = gantry;
		intermodal_logistics_game.associated_prototype_map[gantry.rotations.west.prototype] = gantry;
		--Bogies
		local all_bogies = {
			table.unpack(gantry.rotations.north.bogies),
			table.unpack(gantry.rotations.east.bogies),
			table.unpack(gantry.rotations.south.bogies),
			table.unpack(gantry.rotations.west.bogies) };
		for _, bogey in ipairs(all_bogies) do
			intermodal_logistics_game.associated_prototype_map[bogey.prototype] = gantry;
		end
	end
	for _, dock in pairs(intermodal_logistics_game.docks) do
		dock.type = "dock";
		intermodal_logistics_game.prototype_map[dock.name] = dock;
		-- associations
		intermodal_logistics_game.associated_prototype_map[dock.placement_dummy_prototype] = dock;
	end
	for _, container in pairs(intermodal_logistics_game.containers) do
		container.type = "container";
		intermodal_logistics_game.prototype_map[container.name] = container;
	end
	for _, container_wagon in pairs(intermodal_logistics_game.container_wagons) do
		container_wagon.type = "container-wagon";
		intermodal_logistics_game.prototype_map[container_wagon.name] = container_wagon;
	end
	for _, container_ship in pairs(intermodal_logistics_game.container_ships) do
		container_ship.type = "container-ship";
		intermodal_logistics_game.prototype_map[container_ship.name] = container_ship;
	end

	---Gets a prototype's data given its name.
	---@param prototype_name string The name.
	---@return CustomPrototype # The prototype.
	function intermodal_logistics_game:get_prototype_by_name(prototype_name)
		return self.prototype_map[prototype_name];
	end

	---Gets a prototype's data given its accociated vanilla prototype name.
	---@param prototype_name string The accociated prototype's name.
	---@return CustomPrototype # The prototype.
	function intermodal_logistics_game:get_prototype_by_associated_prototype(prototype_name)
		return self.associated_prototype_map[prototype_name];
	end

	return intermodal_logistics_game;
end

---@return string # The reconstructed jsnot from the data stage.
local function get_jsnot()
	local pipeline = game.recipe_category_prototypes["gantry-data-control-pipeline"];
	---@type string[]
	local jsnot_builder = {};
	for i = 1, #(pipeline.localised_description), 1 do
		table.insert(jsnot_builder, pipeline.localised_description[i]);
	end
	if (type(pipeline.localised_name) == "table") then
		for i = 1, #(pipeline.localised_name), 1 do
			table.insert(jsnot_builder, pipeline.localised_name[i]);
		end
	end
	---@type string
	return table.concat(jsnot_builder);
end


function parse_data_pipeline()
	---@type IntermodalLogisticsGame
	intermodal_logistics_game = make_intermodal_logistics_game(parse_table(get_jsnot()));
end
