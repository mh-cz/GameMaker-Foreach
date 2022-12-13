// v2.0.6

global.FEDATA = [[], undefined, false, false, function() { global.FEDATA[3] = false; return false } ];

#macro fe global.FEDATA[1]

#macro foreach \
	for(global.FEDATA[2] = global.FEDATA[4](); true; { \
	if global.FEDATA[2] { global.FEDATA[3] = true; if !fe.next() { fe.done(); break; } var 

#macro in \
	= fe.get(); } else { global.FEDATA[2] = true; fe = _FeDetectType_(false, 

#macro in_reverse \
	= fe.get(); } else { global.FEDATA[2] = true; fe = _FeDetectType_(true, 

#macro exec \
	); array_push(global.FEDATA[0], fe); }}) if global.FEDATA[3]

#macro as_list ,[ds_type_list]
#macro as_map ,[ds_type_map]
#macro as_grid ,[ds_type_grid]

function _FeDetectType_(reversed, data) {
	
	if is_array(data) return new _FeArray_(reversed, data);
	else if is_string(data) return new _FeString_(reversed, data);
	else if is_struct(data) return new _FeStruct_(data);
	else if argument_count == 3 and is_array(argument[2]) {
		switch(argument[2][0]) {
			case ds_type_list: return new _FeList_(reversed, data);
			case ds_type_map:  return new _FeMap_(data);
			case ds_type_grid: return new _FeGrid_(reversed, data);
			default: throw "Unsupported ds type: " + string(argument[2][0]);
		}
	}
	else if is_numeric(data) {
		if argument_count <= 2 return new _FeRange_(data);
		else if argument_count == 3 return new _FeRange_(data, argument[2])
		else return new _FeRange_(data, argument[2], argument[3]);
	}
	else throw "Unsupported type: " + string(data);
}

function _FeArray_(reversed, data) constructor {

	self.data = data;
	self.i = -1;
	self.len = array_length(data);
	self.step = 1;
		
	if reversed {
		i = len;
		step = -step;
	}

	static set = function(v) {
		data[@ i] = v;
	}

	static next = function() {
		i += step;
		return i < len and i > -1;
	}

	static get = function() {
		return data[i];
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

function _FeList_(reversed, data) constructor {

	self.data = data;
	self.i = -1;
	self.len = ds_list_size(data);
	self.step = 1;

	if reversed {
		i = len;
		step = -step;
	}

	static set = function(v) {
		data[| i] = v;
	}

	static next = function() {
		i += step;
		return i < len and i > -1;
	}

	static get = function() {
		return data[| i];
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

function _FeMap_(data) constructor {

	self.data = data;
	self.i = -1;
	self.key = "";
	self.keys = ds_map_keys_to_array(data);
	self.len = array_length(keys);
	self.step = 1;

	static set = function(v) {
		data[? key] = v;
	}

	static next = function() {
		i += step;
		return i < len;
	}

	static get = function() {
		key = keys[i];
		return data[? key];
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

function _FeStruct_(data) constructor {

	self.data = data;
	self.i = -1;
	self.key = "";
	self.keys = variable_struct_get_names(data);
	self.len = array_length(keys);
	self.step = 1;

	static set = function(v) {
		data[$ key] = v;
	}

	static next = function() {
		i += step;
		return i < len;
	}

	static get = function() {
		key = keys[i];
		return data[$ key];
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

function _FeGrid_(reversed, data) constructor {

	self.data = data;
	self.xpos = 0;
	self.ypos = 0;
	self.w = ds_grid_width(data);
	self.h = ds_grid_height(data);
	self.i = -1;
	self.len = w * h;
	self.step = 1;

	if reversed {
		i = len;
		step = -step;
	}

	static set = function(v) {
		data[# xpos, ypos] = v;
	}

	static next = function() {
		i += step;
		return i < len and i > -1;
	}

	static get = function() {
		xpos = i mod w;
		ypos = i div h;
		return data[# xpos, ypos];
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

function _FeRange_() constructor {

	self.from = -1;
	self.to = 1;
	self.step = 1;
	self.i = 0;

	switch(argument_count) {
		case 1:
			to = argument[0];
			i = from;
			break;
		case 2:
			from = argument[0] - step;
			to = argument[1];
			i = from;
			break;
		case 3:
			step = abs(argument[2]);
			from = argument[0] - step;
			to = argument[1];
			i = from;
			break;
	}

	static next = function() {
		i += step;
		return (from < to and i <= to) or (from > to and i >= to);
	}

	static get = function() {
		return i;
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

function _FeString_(reversed, data) constructor {

	self.data = data;
	self.i = -1;
	self.len = string_length(data);
	self.step = 1;

	if reversed {
		i = len;
		step = -step;
	}

	static next = function() {
		i += step;
		return i < len and i > -1;
	}

	static get = function() {
		return string_char_at(data, i+1);
	}

	static done = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 fe = global.FEDATA[0][l-1];
	}
}

