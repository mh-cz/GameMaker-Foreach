// v2.0.10

// global var for each value (it's faster this way)
global.FEDATA0 = array_create(10, undefined); // STACK
global.FEDATA1 = undefined; // CURRENT LOOP (fe)
global.FEDATA2 = false; // DATA LOADED
global.FEDATA3 = false; // i < len
global.FEDATA4 = -1; // CURRENT STACK INDEX

#macro fe global.FEDATA1
#macro fe_break { fe.done(); break; }

#macro foreach \
	for(global.FEDATA2 = false; true; {  

#macro in \
	= global.FEDATA2 ? fe.get() : _FeAuto_(false, 

#macro in_reverse \
	= global.FEDATA2 ? fe.get() : _FeAuto_(true, 

#macro exec \
	); if !global.FEDATA3 fe_break; }) if global.FEDATA2

#macro as_list , undefined, ds_type_list
#macro as_map , undefined, ds_type_map
#macro as_grid , undefined, ds_type_grid

function fe_return(val) {
	fe.done();
	return val;
}

function _FeAuto_(a0, a1, a2 = undefined, a3 = undefined) {

	if a2 == undefined and a3 != undefined switch(a3) {
		case ds_type_list: fe = new _FeList_(a0, a1); break;
		case ds_type_map:  fe = new _FeMap_(a1);	  break;
		case ds_type_grid: fe = new _FeGrid_(a0, a1); break;
		default: throw "Unsupported DS type";
	}
	else if is_array(a1) fe = new _FeArray_(a0, a1);
	else if is_string(a1) fe = new _FeString_(a0, a1);
	else if is_struct(a1) fe = new _FeStruct_(a1);
	else if is_numeric(a1) {
		if a2 == undefined fe = new _FeRange_(0, a1, 1);
		else if a3 == undefined fe = new _FeRange_(a1, a2, 1)
		else fe = new _FeRange_(a1, a2, a3)
	}
	else throw "Unsupported type";
	
	global.FEDATA2 = true;
	global.FEDATA0[@ ++global.FEDATA4] = fe;
	return fe.get(false);
}

function _FeArray_() constructor {
 
	rev = argument0;	// had to do it this way
	data = argument1;	// otherwise Feather won't shut up
	len = array_length(data);
	i = rev ? len-1 : 0;
	step = rev ? -1 : 1;
	
	static set = function(v) {
		data[@ i] = v;
	}

	static next = function() {
		i += step;
		return in_range();
	}
	
	static in_range = function() {
		return i < len and i > -1;	
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		return (global.FEDATA3 ? data[@ i] : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}

function _FeList_() constructor {

	rev = argument0;
	data = argument1;
	len = ds_list_size(data);
	i = rev ? len-1 : 0;
	step = rev ? -1 : 1;

	static set = function(v) {
		data[| i] = v;
	}

	static next = function() {
		i += step;
		return in_range();
	}
	
	static in_range = function() {
		return i < len and i > -1;	
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		return (global.FEDATA3 ? data[| i] : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}

function _FeMap_() constructor {

	data = argument0;
	i = 0;
	key = "";
	keys = ds_map_keys_to_array(data);
	len = array_length(keys);
	step = 1;

	static set = function(v) {
		data[? key] = v;
	}
	
	static next = function() {
		i += step;
		return in_range();
	}
	
	static in_range = function() {
		return i < len and i > -1;	
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		if global.FEDATA3 key = keys[@ i];
		return (global.FEDATA3 ? data[? key] : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}

function _FeStruct_() constructor {

	data = argument0;
	i = 0;
	key = "";
	keys = variable_struct_get_names(data);
	len = array_length(keys);
	step = 1;

	static set = function(v) {
		data[$ key] = v;
	}

	static next = function() {
		i += step;
		return in_range();
	}
	
	static in_range = function() {
		return i < len and i > -1;	
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		if global.FEDATA3 key = keys[@ i];
		return (global.FEDATA3 ? data[$ key] : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}

function _FeGrid_() constructor {

	rev = argument0;
	data = argument1;
	xpos = 0;
	ypos = 0;
	w = ds_grid_width(data);
	h = ds_grid_height(data);
	len = w * h;
	i = rev ? len-1 : 0;
	step = rev ? -1 : 1;
	
	static set = function(v) {
		data[# xpos, ypos] = v;
	}
	
	static next = function() {
		i += step;
		xpos = i mod w;
		ypos = i div h;
		return in_range();
	}

	static in_range = function() {
		return i < len and i > -1;	
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		if global.FEDATA3 {
			xpos = i mod w;
			ypos = i div h;
		}
		return (global.FEDATA3 ? data[# xpos, ypos] : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}

function _FeRange_() constructor {

	from = argument0;
	to = argument1;
	step = argument2;
	i = from;

	static next = function() {
		i += step;
		return in_range();
	}

	static in_range = function() {
		return (from < to and i <= to) or (from > to and i >= to);
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		return (global.FEDATA3 ? i : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}

function _FeString_() constructor {

	rev = argument0;
	data = argument1;
	len = string_length(data);
	i = rev ? len-1 : 0;
	step = rev ? -1 : 1;

	static next = function() {
		i += step;
		return in_range();
	}
	
	static in_range = function() {
		return i < len and i > -1;	
	}

	static get = function(nxt = true) {
		global.FEDATA3 = (nxt ? next() : in_range());
		return (global.FEDATA3 ? string_char_at(data, i+1) : undefined);
	}

	static done = function() {
		fe = (--global.FEDATA4 != -1 ? global.FEDATA0[@ global.FEDATA4] : undefined);
	}
}
