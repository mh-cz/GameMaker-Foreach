function foreach_init() {
	
	globalvar fed;
	fed = {
		stacks: ds_stack_create(),
		cs : -1, // current stack in loop
		
		break_input: function(stack) {
			if is_array(stack.name) { 
				var name_overwrite = "";
				var len = array_length(stack.name);
				
				if len == 1 name_overwrite = stack.name[0];
				else if len > 1 {
					if is_string(stack.name[0]) and is_string(stack.name[1]) {
						stack.iname = stack.name[0];
						name_overwrite = stack.name[1];
						if len >= 3 stack.step = stack.name[2];
						if len == 4 stack.startfrom = stack.name[3];
					}
					else if is_string(stack.name[0]) and is_real(stack.name[1]) {
						name_overwrite = stack.name[0];
						stack.step = stack.name[1];
						if len == 3 stack.startfrom = stack.name[2];
					}
				}
				stack.name = name_overwrite;
			}
		},
		
		break_range_arr: function(stack) {
			if is_array(stack.input) {
				var len = array_length(stack.input);
				if len == 1 stack.to = stack.input[0];
				else if len >= 2 {
					stack.from = stack.input[0];
					stack.to = stack.input[1];
					if len == 3 stack.step = (stack.input[2] == 0) ? 1 : abs(stack.input[2]);
				}
			}
			else stack.to = stack.input;
		},
		
		set: function(val) { 
			switch(fed.cs.data_type) {
				case 0: fed.cs.input[@ fed.cs.i] = val; break;
				case 1: fed.cs.input[| fed.cs.i] = val; break;
				case 2: fed.cs.input[? fed.cs.key] = val; break;
				case 3: fed.cs.input[# fed.cs.xpos, fed.cs.ypos] = val; break;
				case 4: fed.cs.input = string_delete(fed.cs.input, fed.cs.i+1, 1);
						fed.cs.input = string_insert(string(val), fed.cs.input, fed.cs.i+1); break;
				case 5: fed.cs.input[$ fed.cs.key] = val; break;
			}
			return val;
		}
	};
	
	#macro foreach \
		ds_stack_push(fed.stacks, { name: "", iname: "", input: undefined, i: 0, startfrom: 0, step: 1, len: 0, xpos: 0, xlen: 0, ypos: 0, ylen: 0, key: "", keys: [], data_type: -1, from: 0, to: 0 }); \
		ds_stack_top(fed.stacks).name =
	
	#macro in \
		ds_stack_top(fed.stacks).input =
	
	// ARRAY
	#macro as_array \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.len = array_length(fed.cs.input); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 0; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[@ fed.cs.startfrom]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.startfrom); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.startfrom; true; \
			{ \
				fed.cs.i += fed.cs.step; \
				if fed.cs.i < fed.cs.len { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[@ fed.cs.i]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// LIST
	#macro as_list \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.len = ds_list_size(fed.cs.input); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 1; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[| fed.cs.startfrom]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.startfrom); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.startfrom; true; \
			{ \
				fed.cs.i += fed.cs.step; \
				if fed.cs.i < fed.cs.len { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[| fed.cs.i]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// MAP
	#macro as_map \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.key = ds_map_find_first(fed.cs.input); \
		if fed.cs.key != undefined and fed.cs.startfrom < ds_map_size(fed.cs.input) { \
			fed.cs.data_type = 2; \
			fed.break_input(fed.cs); \
			repeat(fed.cs.startfrom) { fed.cs.key = ds_map_find_next(fed.cs.input, fed.cs.key); } \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[? fed.cs.key]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.key); \
		} \
		if fed.cs.key == undefined or fed.cs.startfrom >= ds_map_size(fed.cs.input) { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(; true; \
			{ \
				repeat(fed.cs.step) { fed.cs.key = ds_map_find_next(fed.cs.input, fed.cs.key); } \
				if !is_undefined(fed.cs.key) { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[? fed.cs.key]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.key); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// GRID
	#macro as_grid \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.xlen = ds_grid_width(fed.cs.input); \
		fed.cs.ylen = ds_grid_height(fed.cs.input); \
		fed.cs.len = fed.cs.xlen * fed.cs.ylen; \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 3; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[# fed.cs.startfrom, fed.cs.startfrom]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, [fed.cs.startfrom, fed.cs.startfrom]); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom < fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(; true; \
			{ \
				fed.cs.i += fed.cs.step; \
				if fed.cs.i < fed.cs.len { \
					fed.cs.ypos += fed.cs.step; \
					if fed.cs.ypos > fed.cs.ylen-1 { \
						fed.cs.ypos += fed.cs.step; \
						fed.cs.ypos = 0; \
						fed.cs.xpos++; \
					} \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[# fed.cs.xpos, fed.cs.ypos]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, [fed.cs.xpos, fed.cs.ypos]); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// STRING
	#macro as_string \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.len = string_length(fed.cs.input); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 4; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, string_char_at(fed.cs.input, fed.cs.startfrom+1)); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.startfrom); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.startfrom; true; \
			{ \
				fed.cs.i += fed.cs.step; \
				if fed.cs.i < fed.cs.len { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, string_char_at(fed.cs.input, fed.cs.i+1)); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// STRUCT
	#macro as_struct \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.keys = variable_struct_get_names(fed.cs.input); \
		fed.cs.len = array_length(fed.cs.keys); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 5; \
			fed.break_input(fed.cs); \
			fed.cs.key = fed.cs.keys[fed.cs.startfrom]; \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[$ fed.cs.key]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.key); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.startfrom; true; \
			{ \
				fed.cs.i += fed.cs.step; \
				if fed.cs.i < fed.cs.len { \
					fed.cs.key = fed.cs.keys[fed.cs.i]; \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[$ fed.cs.key]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.key); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// NUMBER RANGE
	#macro as_range \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.break_range_arr(fed.cs) \
		if fed.cs.from != fed.cs.to { \
			fed.cs.data_type = 6; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.from); \
		} \
		if fed.cs.from == fed.cs.to { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.from; true; \
			{ \
				fed.cs.i += sign(fed.cs.to - fed.cs.from) * fed.cs.step; \
				if (fed.cs.from < fed.cs.to and fed.cs.i < fed.cs.to) \
				or (fed.cs.from > fed.cs.to and fed.cs.i > fed.cs.to) { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// INVERSE ARRAY
	#macro as_inv_array \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.len = array_length(fed.cs.input); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 0; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[@ fed.cs.len-1 - fed.cs.startfrom]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.len-1 - fed.cs.startfrom); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.len-1 - fed.cs.startfrom; true; \
			{ \
				fed.cs.i -= fed.cs.step; \
				if fed.cs.i > -1 { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[@ fed.cs.i]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// INVERSE LIST
	#macro as_inv_list \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.len = ds_list_size(fed.cs.input); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 1; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[| fed.cs.len-1 - fed.cs.startfrom]); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.len-1 - fed.cs.startfrom); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.len-1 - fed.cs.startfrom; true; \
			{ \
				fed.cs.i -= fed.cs.step; \
				if fed.cs.i > -1 { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, fed.cs.input[| fed.cs.i]); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
	
	// INVERSE STRING
	#macro as_inv_string \
		fed.cs = ds_stack_top(fed.stacks); \
		fed.cs.len = string_length(fed.cs.input); \
		if fed.cs.len != 0 and fed.cs.startfrom < fed.cs.len { \
			fed.cs.data_type = 4; \
			fed.break_input(fed.cs); \
			if fed.cs.name != "" variable_instance_set(id, fed.cs.name, string_char_at(fed.cs.input, fed.cs.len-1 - fed.cs.startfrom+1)); \
			if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.len-1 - fed.cs.startfrom); \
		} \
		if fed.cs.len == 0 or fed.cs.startfrom >= fed.cs.len { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); } \
		else for(fed.cs.i = fed.cs.len-1 - fed.cs.startfrom; true; \
			{ \
				fed.cs.i -= fed.cs.step; \
				if fed.cs.i > -1 { \
					if fed.cs.name != "" variable_instance_set(id, fed.cs.name, string_char_at(fed.cs.input, fed.cs.i+1)); \
					if fed.cs.iname != "" variable_instance_set(id, fed.cs.iname, fed.cs.i); \
				} else { ds_stack_pop(fed.stacks); fed.cs = ds_stack_top(fed.stacks); break; } \
			})
}
