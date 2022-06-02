// v2.0.3

global.FEDATA = [[], -1];

function _FeArray_(inv, data) constructor {	
	self.data = data;
	self.i = -1;
	self.len = array_length(data);
	self.step = 1;

	if inv {
		i = len;
		step = -step;
	}

	static map = function(v) {
		data[@ i] = v;
	}

	static next = function() {
		i += step;
		return i < len and i > -1;
	}

	static get = function() {
		return data[i];
	}

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

function _FeList_(inv, data) constructor {

	self.data = data;
	self.i = -1;
	self.len = ds_list_size(data);
	self.step = 1;

	if inv {
		i = len;
		step = -step;
	}

	static map = function(v) {
		data[| i] = v;
	}

	static next = function() {
		i += step;
		return i < len and i > -1;
	}

	static get = function() {
		return data[| i];
	}

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

function _FeMap_(data) constructor {

	self.data = data;
	self.i = -1;
	self.key = "";
	self.keys = ds_map_keys_to_array(data);
	self.len = array_length(keys);
	self.step = 1;

	static map = function(v) {
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

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

function _FeStruct_(data) constructor {

	self.data = data;
	self.i = -1;
	self.key = "";
	self.keys = variable_struct_get_names(data);
	self.len = array_length(keys);
	self.step = 1;

	static map = function(v) {
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

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

function _FeGrid_(inv, data) constructor {

	self.data = data;
	self.xpos = 0;
	self.ypos = 0;
	self.w = ds_grid_width(data);
	self.h = ds_grid_height(data);
	self.i = -1;
	self.len = w * h;
	self.step = 1;

	if inv {
		i = len;
		step = -step;
	}

	static map = function(v) {
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

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

function _FeRange_() constructor {

	self.from = 0;
	self.to = 1;
	self.step = 1;
	self.i = 0;

	switch(argument_count) {
		case 1:
			to = argument0;
			break;
		case 2:
			from = argument0 - step;
			to = argument1;
			i = from;
			break;
		case 3:
			step = abs(argument2);
			from = argument0 - step;
			to = argument1;
			i = from;
			break;
	}

	static map = function(v) {
		data[# xpos, ypos] = v;
	}

	static next = function() {
		i += step;
		return (from < to and i <= to) or (from > to and i >= to);
	}

	static get = function() {
		return i;
	}

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

function _FeString_(inv, data) constructor {

	self.data = data;
	self.i = -1;
	self.len = string_length(data);
	self.step = 1;

	if inv {
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

	static yeet = function() {
		array_pop(global.FEDATA[0]);
		var l = array_length(global.FEDATA[0]);
		if l != 0 Loop = global.FEDATA[0][l-1];
	}
}

#macro Loop global.FEDATA[1]

#macro Foreach \
	for(var _DataLoadeD_ = false, _CanLooP_ = false; true; { \
	if _DataLoadeD_ { _CanLooP_ = true; if !Loop.next() { Loop.yeet(); break; } var 

#macro Feach \
	for(var _DataLoadeD_ = false, _CanLooP_ = false; true; { \
	if _DataLoadeD_ { _CanLooP_ = true; if !Loop.next() { Loop.yeet(); break; } var 

#macro Run \
	); array_push(global.FEDATA[0], Loop); } \
	}) if _CanLooP_

#macro inArray \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeArray_(false, 

#macro inInvArray \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeArray_(true, 

#macro inList \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeList_(false, 

#macro inInvList \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeList_(true, 

#macro inMap \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeMap_(

#macro inStruct \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeStruct_(

#macro inGrid \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeGrid_(false, 

#macro inInvGrid \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeGrid_(true, 

#macro inRange \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeRange_( 

#macro inString \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeString_(false, 

#macro inInvString \
	= Loop.get(); } else { _DataLoadeD_ = true; Loop = new _FeString_(true, 

