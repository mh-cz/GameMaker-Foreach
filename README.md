# GameMaker Foreach v2

A stackable foreach loop for arrays, lists, maps, structs, grids, strings and number ranges.

This foreach was made using macros so you don't have to pass variables like arguments. You can access them inside of the loop directly. 

Reserved keywords: `feach, foreach, in, as_array, as_list, as_map, as_struct, as_grid, as_string, as_range, BREAK, CONTINUE` + global variable `fe`.

### Changelog
[2.0.0] Redone from scratch
- Data is returned inside a global struct `fe` so it can be called in anonymous functions
- You can no longer only use variable names that don't exist yet
- You only type the return value name. Iterator/Key names are created automatically using `i_` and `k_` prefixes (`x_`, `y_` for grid)
- It's a true one-liner now so you can call it without surrounding it with brackets
- Map function is simpler to use
- `BREAK` and `CONTINUE` macros
- The code is not a fking mess anymore

### How to use it
Call `foreach_init()` once when the game starts and you're good to go.

### Syntax
`feach <VALUE_NAME>, <START_FROM>, <STEP> in <DATA> as_<DATA_TYPE>`

- VALUE_NAME - string, required
- START_FROM - real, optional
- STEP - real, optional
- DATA - any supported data
- DATA_TYPE - type of the entered data
####
- Use capital `BREAK;` macro to exit the loop when mapping/changing values. This will force the map function to register the changed value immediately instead of the next iteration since there is no next iteration after calling `break`
- The `CONTINUE;` macro is there just for consistency. You can use regular `continue` if you want

## Examples
Array - return value
```
var arr = [1, 2, 3, 4];

feach "v" in arr as_array
	show_debug_message(fe.v);
 
> 1
> 2
> 3
> 4
```
Array - return value and index
```
var arr = ["a","b","c","d"];

feach "v" in arr as_array
	show_debug_message(string(fe.i_v) + ", " + string(fe.v));  // prefix i_<value_name> returns the index
 
> 0, a
> 1, b
> 2, c
> 3, d
```
Array - simple map
```
var arr = [1, 2, 3, 4];
var multip = 10;

feach "num" in arr as_array
	fe.num *= multip;

The array now contains: [10, 20, 30, 40]
```
List - change some values inside
```
var some_values = ds_list_create();
some_values[| 0] = 1; 
some_values[| 1] = 2;
some_values[| 2] = 3; 
some_values[| 3] = 4;

var add = 10;

feach "v" in some_values as_list {
	     if fe.i_v == 1 fe.v *= -1;
	else if fe.i_v == 2 fe.v = sqr(fe.v);
	else if fe.i_v == 3 fe.v += add;
}

// now return them
feach "v" in some_values as_list show_debug_message(fe.v);

> 1
> -2
> 9
> 14
```
Grid - store cell coordinate into each cell
```
var grd = ds_grid_create(3,3);

feach "v" in grd as_grid
	fe.v = [fe.x_v, fe.y_v];  // prefixes x_<value_name>, y_<value_name> returns the x, y grid coords

The grid now contains:
[0,0] [1,0] [2,0]
[0,1] [1,1] [2,1]
[0,2] [1,2] [2,2]
```
Struct - loop until undefined value is found, set it to 0 and return the key of the undefined value
```
var animals = {
	dogs: 10,
	cats: 4,
	rats: 9,
	cows: undefined,
	goats: 2,
};

var undef_keys = [];
feach "animal_count" in animals as_struct {
	if is_undefined(fe.animal_count) {
		array_push(undef_keys, fe.k_animal_count);  // prefix k_<value_name> returns the key
		fe.animal_count = 0;
	}
}

> undef_key now contains string ["cows"]
```

Stackable like regular for loop
```
feach "v" in some_arr as_array
	feach "v" in some_struct as_struct
		feach "v" in some_map as_map
			do_something();


feach "v" in some_arr as_array {
	do_something();
	feach "v" in some_struct as_struct {
		do_something_else();
		feach "v" in some_map as_map {
			do_something_else_else();
		}
	}
}
```
One-liner possibilities
```
if !is_array(data) {
	do_something(data);
	do_something_else(data);
}
else feach "v" in some_arr as_array {  // running foreach right after "else" wasn't possible before
	do_something(fe.v);
	do_something_else(fe.v);
}
```

