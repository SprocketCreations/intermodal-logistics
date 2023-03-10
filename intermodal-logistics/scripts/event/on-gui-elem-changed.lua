
require("scripts.gui.gantry-filters-gui");
require("scripts.util.get-gui-stuff");
require("scripts.util.get-gantry-request-filters-gui");

function on_gui_elem_changed(event)
	-- Gantry Filters
	if (event.element.parent.name == "gantry_request_filters") then
		local player, socket, conditionals = get_gui_stuff(event.player_index);
		-- Get the filter
		local value = event.element.elem_value;
		-- Get the button index
		local index = event.element.get_index_in_parent();
		local number_of_buttons = #(event.element.parent.children);
		-- If this picker is on the last row and we are adding a value
		if (index > number_of_buttons - 10 and value ~= nil) then
			-- we want to add another row
			add_filter_button_row(get_gantry_request_filters_gui(player), 1);
		end
		-- Set the filter to the new value;
		socket_set_filter(socket, index, value);
		return;
	end
	-- Gantry Conditons
	do
		local switch = {
			["gantry_choose_item_button_left"] = function()
				local player, socket, conditionals = get_gui_stuff(event.player_index);
				local index = event.element.parent.parent.parent.parent.get_index_in_parent();
				local item = event.element.elem_value;
				local condition = conditional_get_condition(conditionals, index);
				condition.left_item = item;
			end,
			["gantry_choose_signal_button_left"] = function()
				local player, socket, conditionals = get_gui_stuff(event.player_index);
				local index = event.element.parent.parent.parent.parent.get_index_in_parent();
				local signal = event.element.elem_value;
				local condition = conditional_get_condition(conditionals, index);
				condition.left_signal = signal;
			end,
			["gantry_choose_signal_button_right"] = function()
				local player, socket, conditionals = get_gui_stuff(event.player_index);
				local index = event.element.parent.parent.parent.parent.get_index_in_parent();
				local signal = event.element.elem_value;
				local condition = conditional_get_condition(conditionals, index);
				condition.right_signal = signal;
			end,
		};
		local handler = switch[event.element.name];
		if (handler ~= nil) then handler() end
	end
end
