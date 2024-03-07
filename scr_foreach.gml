// Foreach v3.0.1

#region GLOBAL

global._FE_STACK = array_create(10, undefined);
global._FE_CURR_STACK_INDEX = -1;
global._FE = undefined;

#endregion

#region MACROS

#macro fe global._FE
#macro fe_break fe.fn = fe.end_loop; break
#macro fe_continue break
#macro fe_return return _FE_RETURN

#macro as_list ,undefined,ds_type_list
#macro as_map ,undefined,ds_type_map
#macro as_grid ,undefined,ds_type_grid

#macro foreach \
	for(_FE_AUTO_(

#macro foreach_rev \
	for(_FE_AUTO_REV_(

#macro into \
	); fe.fn(); ) for(var 

#macro exec \
	 = fe.get(); true; break)

#endregion

#region RETURN

function _FE_RETURN(val, _depth = 1) {
	repeat(_depth) fe.end_loop();
	return val;
}

#endregion

#region AUTO

function _FE_AUTO_(a1, a2 = undefined, a3 = undefined) {
	
	if a2 == undefined and a3 != undefined switch(a3) {
		case ds_type_list: fe = new _FE_LIST_(a1); break;
		case ds_type_map: fe = new _FE_MAP_(a1); break;
		case ds_type_grid: fe = new _FE_GRID_(a1); break;
		default: throw "Unsupported DS type";
	}
	else if is_array(a1) fe = new _FE_ARRAY_(a1);
	else if is_string(a1) fe = new _FE_STRING_(a1);
	else if is_struct(a1) fe = new _FE_STRUCT_(a1);
	else if is_numeric(a1) {
		if a2 == undefined fe = new _FE_RANGE_(0, a1, 1);
		else if a3 == undefined fe = new _FE_RANGE_(a1, a2, 1)
		else fe = new _FE_RANGE_(a1, a2, a3)
	}
	else throw "Unsupported type";
	
	global._FE_STACK[@ ++global._FE_CURR_STACK_INDEX] = fe;
}

function _FE_AUTO_REV_(a1, a2 = undefined, a3 = undefined) {
	
	if a2 == undefined and a3 != undefined switch(a3) {
		case ds_type_list: fe = new _FE_LIST_REV_(a1); break;
		case ds_type_map: fe = new _FE_MAP_(a1); break;
		case ds_type_grid: fe = new _FE_GRID_REV_(a1); break;
		default: throw "Unsupported DS type";
	}
	else if is_array(a1) fe = new _FE_ARRAY_REV_(a1);
	else if is_string(a1) fe = new _FE_STRING_REV_(a1);
	else if is_struct(a1) fe = new _FE_STRUCT_(a1);
	else if is_numeric(a1) {
		if a2 == undefined fe = new _FE_RANGE_(a1, 0, 1);
		else if a3 == undefined fe = new _FE_RANGE_(a2, a1, 1)
		else fe = new _FE_RANGE_(a2, a1, a3)
	}
	else throw "Unsupported type";
	
	global._FE_STACK[@ ++global._FE_CURR_STACK_INDEX] = fe;
}

#endregion

#region ARRAY

function _FE_ARRAY_() constructor {

	data = argument0;
	len = array_length(data);
	i = -1;

	static set = function(v) {
		data[@ i] = v;
	}

	static next = function() {
		return ++i < len ? true : end_loop();
	}
	
	static get = function() {
		return data[@ i];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

function _FE_ARRAY_REV_() constructor {

	data = argument0;
	len = array_length(data);
	i = len;

	static set = function(v) {
		data[@ i] = v;
	}

	static next = function() {
		return --i > -1 ? true : end_loop();
	}
	
	static get = function() {
		return data[@ i];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

#region STRING

function _FE_STRING_() constructor {

	data = argument0;
	len = string_length(data);
	i = -1;

	static set = function(v) {}

	static next = function() {
		return ++i < len ? true : end_loop();
	}
	
	static get = function() {
		return string_char_at(data, i+1);
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

function _FE_STRING_REV_() constructor {

	data = argument0;
	len = string_length(data);
	i = len;

	static set = function(v) {}

	static next = function() {
		return --i > -1 ? true : end_loop();
	}
	
	static get = function() {
		return string_char_at(data, i+1);
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

#region LIST

function _FE_LIST_() constructor {

	data = argument0;
	len = ds_list_size(data);
	i = -1;

	static set = function(v) {
		data[| i] = v;
	}

	static next = function() {
		return ++i < len ? true : end_loop();
	}
	
	static get = function() {
		return data[| i];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

function _FE_LIST_REV_() constructor {

	data = argument0;
	len = ds_list_size(data);
	i = len;

	static set = function(v) {
		data[| i] = v;
	}

	static next = function() {
		return --i > -1 ? true : end_loop();
	}
	
	static get = function() {
		return data[| i];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

#region STRUCT

function _FE_STRUCT_() constructor {

	data = argument0;
	key = "";
	keys = variable_struct_get_names(data);
	len = array_length(keys);
	i = -1;

	static set = function(v) {
		data[$ i] = v;
	}

	static next = function() {
		return ++i < len ? true : end_loop();
	}
	
	static get = function() {
		key = keys[@ i];
		return data[$ key];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

#region MAP

function _FE_MAP_() constructor {

	data = argument0;
	key = "";
	keys = ds_map_keys_to_array(data);
	len = array_length(keys);
	i = -1;

	static set = function(v) {
		data[? key] = v;
	}

	static next = function() {
		return ++i < len ? true : end_loop();
	}
	
	static get = function() {
		key = keys[@ i];
		return data[? key];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

#region GRID

function _FE_GRID_() constructor {

	data = argument0;
	xpos = 0;
	ypos = 0;
	w = ds_grid_width(data);
	h = ds_grid_height(data);
	len = w * h;
	i = -1;

	static set = function(v) {
		data[# xpos, ypos] = v;
	}

	static next = function() {
		return ++i < len ? true : end_loop();
	}
	
	static get = function() {
		xpos = i mod w;
		ypos = i div h;
		return data[# xpos, ypos];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

function _FE_GRID_REV_() constructor {

	data = argument0;
	xpos = 0;
	ypos = 0;
	w = ds_grid_width(data);
	h = ds_grid_height(data);
	len = w * h;
	i = len;

	static set = function(v) {
		data[# xpos, ypos] = v;
	}

	static next = function() {
		return --i > -1 ? true : end_loop();
	}
	
	static get = function() {
		xpos = i mod w;
		ypos = i div h;
		return data[# xpos, ypos];
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

#region RANGE

function _FE_RANGE_() constructor {

	from = argument0;
	to = argument1;
	step = abs(argument2) * sign(to - from);
	i = from - step;
	
	static set = function(v) {}

	static next = function() {
		i += step;
		return (from < to and i <= to) or (from > to and i >= to) ? true : end_loop();
	}
	
	static get = function() {
		return i;
	}
	
	static end_loop = function() {
		global._FE = --global._FE_CURR_STACK_INDEX != -1 ? global._FE_STACK[@ global._FE_CURR_STACK_INDEX] : undefined;
		return false;
	}
	
	fn = next;
}

#endregion

