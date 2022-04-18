// v2.0.1
function foreach_init() {
	
	globalvar fe;
	fe = {
		_: {
			stack: ds_stack_create(), 
			cs: -1,
			
			dt_array: 0,
			dt_string: 1,
			dt_list: 2,
			dt_map: 3,
			dt_struct: 4,
			dt_grid: 5,
			dt_range: 6,
			
			new_stack: function() {
				ds_stack_push(fe._.stack, { 
					args: [], 
					data: [],
					i: 0, 
					step: 1, 
					key: "", 
					keys: [],
					len: 0,
					wlen: 0,
					hlen: 0,
					wi: 0,
					hi: 0,
					datatype: -1,
					from: 0,
					to: 0,
					inv: false,
				});
				fe._.cs = ds_stack_top(fe._.stack);
			},
			
			prepare_loop: function(args, data, datatype, inversed = false) {
				
				fe._.new_stack();
				fe._.cs.args = args;
				fe._.cs.data = data;
				fe._.cs.datatype = datatype;
				fe._.cs.inv = inversed;
				
				var arg_l = array_length(args);
				if arg_l >= 2 fe._.cs.i = args[1];
				if arg_l == 3 fe._.cs.step = args[2];
				
				if arg_l > 0 and is_string(args[0]) {
					switch(datatype) {
						case fe._.dt_array:
							fe._.cs.len = array_length(data[0]);
							break;
						case fe._.dt_list:
							fe._.cs.len = ds_list_size(data[0]);
							break;
						case fe._.dt_string:
							fe._.cs.len = string_length(data[0]);
							break;
						case fe._.dt_grid:
							fe._.cs.wlen = ds_grid_width(data[0]);
							fe._.cs.hlen = ds_grid_height(data[0]);
							fe._.cs.len = fe._.cs.wlen * fe._.cs.hlen;
							break;
						case fe._.dt_map:
							fe._.cs.keys = ds_map_keys_to_array(data[0]);
							fe._.cs.len = array_length(fe._.cs.keys);
							break;
						case fe._.dt_struct:
							fe._.cs.keys = variable_struct_get_names(data[0]);
							fe._.cs.len = array_length(fe._.cs.keys);
							break;
					}
				}
				return 0;
			},
			
			return_data: function() {
				if !(fe._.cs.i < fe._.cs.len) return fe._.exit_loop();
				
				var i = fe._.cs.inv ? fe._.cs.len-1 - fe._.cs.i : fe._.cs.i;
				var name = fe._.cs.args[0];
				
				switch(fe._.cs.datatype) {
					case fe._.dt_array:
						fe[$ "i_"+name] = i;
						fe[$ name] = fe._.cs.data[0][@ i];
						break;
					case fe._.dt_list:
						fe[$ "i_"+name] = i;
						fe[$ name] = fe._.cs.data[0][| i];
						break;
					case fe._.dt_string:
						fe[$ "i_"+name] = i;
						fe[$ name] = string_char_at(fe._.cs.data[0], i + 1);
						break;
					case fe._.dt_grid:
						fe._.cs.wi = i mod fe._.cs.wlen;
						fe._.cs.hi = i div fe._.cs.hlen;
						fe[$ "i_"+name] = i;
						fe[$ "x_"+name] = fe._.cs.wi;
						fe[$ "y_"+name] = fe._.cs.hi;
						fe[$ name] = fe._.cs.data[0][# fe._.cs.wi, fe._.cs.hi];
						break;
					case fe._.dt_map:
						fe._.cs.key = fe._.cs.keys[fe._.cs.i];
						fe[$ "k_"+name] = fe._.cs.key;
						fe[$ name] = fe._.cs.data[0][? fe._.cs.key];
						break;
					case fe._.dt_struct:
						fe._.cs.key = fe._.cs.keys[fe._.cs.i];
						fe[$ "k_"+name] = fe._.cs.key;
						fe[$ name] = fe._.cs.data[0][$ fe._.cs.key];
						break;
				}
				return true;
			},
			
			map: function() {
				if !(fe._.cs.i < fe._.cs.len) return false;
				
				var i = fe._.cs.inv ? fe._.cs.len-1 - fe._.cs.i : fe._.cs.i;
				var name = fe._.cs.args[0];
				
				switch(fe._.cs.datatype) {
					case fe._.dt_array:  fe._.cs.data[0][@ i] = fe[$ name]; break;
					case fe._.dt_list:   fe._.cs.data[0][| i] = fe[$ name]; break;
					case fe._.dt_grid:	 fe._.cs.data[0][# fe._.cs.wi, fe._.cs.hi] = fe[$ name]; break;
					case fe._.dt_map:	 fe._.cs.data[0][? fe._.cs.key] = fe[$ name]; break;
					case fe._.dt_struct: fe._.cs.data[0][$ fe._.cs.key] = fe[$ name]; break;
				}
			},
			
			next: function() {
				fe._.map();
				fe._.cs.i += fe._.cs.step;	
			},
			
			exit_loop: function() {
				ds_stack_pop(fe._.stack);
				fe._.cs = ds_stack_top(fe._.stack);
				return false;
			},
			
			prepare_range: function(args, data, datatype) {
				
				fe._.new_stack();
				
				var l = array_length(data);
				if l == 1 {
					fe._.cs.from = 0;
					fe._.cs.to = data[0];
					fe._.cs.step = 1;
				}
				else if l == 2 {
					fe._.cs.from = data[0];
					fe._.cs.to = data[1];
					fe._.cs.step = 1;
				}
				else if l == 3 {
					fe._.cs.from = data[0];
					fe._.cs.to = data[1];
					fe._.cs.step = abs(data[2]);
				}
				
				fe._.cs.i = fe._.cs.from;
				fe._.cs.args = args;
				fe._.cs.datatype = datatype;
			},
			
			return_num: function() {
				if (fe._.cs.from < fe._.cs.to and fe._.cs.i < fe._.cs.to)
				or (fe._.cs.from > fe._.cs.to and fe._.cs.i > fe._.cs.to) {
					fe[$ fe._.cs.args[0]] = fe._.cs.i;
					return true;
				}
				return fe._.exit_loop();
			},
			
			next_num: function() {
				fe._.cs.i += sign(fe._.cs.to - fe._.cs.from) * fe._.cs.step;
			},
			
		},
	};
	
	#macro BREAK \
		{ fe._.map(); break; }
		
	#macro CONTINUE \
		continue;
	
	#macro feach \
		for(var _feARGS_ = [
		
	#macro foreach \
		for(var _feARGS_ = [
	
	#macro in \
		], _feDATA_ = [
	
	#macro as_array \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_array); fe._.return_data(); fe._.next())
		
	#macro as_inv_array \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_array, true); fe._.return_data(); fe._.next())
		
	#macro as_list \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_list); fe._.return_data(); fe._.next())
		
	#macro as_inv_list \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_list, true); fe._.return_data(); fe._.next())
		
	#macro as_string \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_string); fe._.return_data(); fe._.next())
		
	#macro as_inv_string \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_string, true); fe._.return_data(); fe._.next())
	
	#macro as_grid \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_grid); fe._.return_data(); fe._.next())
	
	#macro as_inv_grid \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_grid, true); fe._.return_data(); fe._.next())
	
	#macro as_map \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_map); fe._.return_data(); fe._.next())
	
	#macro as_struct \
		], _fePREPARE_ = fe._.prepare_loop(_feARGS_, _feDATA_, fe._.dt_struct); fe._.return_data(); fe._.next())
	
	#macro as_range \
		], _fePREPARE_ = fe._.prepare_range(_feARGS_, _feDATA_, fe._.dt_range); fe._.return_num(); fe._.next_num())
	
}

