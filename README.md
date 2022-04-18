# GameMaker Foreach v2
Redone from scratch

A stackable foreach loop for arrays, lists, maps, structs, grids, strings and number ranges.

This foreach was made using macros so you don't have to pass variables like arguments. Just type them directly. 

Reserved keywords: `feach, in, as_array, as_list, as_map, as_struct, as_grid, as_string, as_range` + global variable `fe`.

Call `foreach_init()` once when the game starts and you're good to go.

#### What changed
In version 1 the data was returned using `variable_instance_set` which required an instance for it to run.

In version 2 the data is returned inside a global struct `fe` so it can be called in anonymous functions.
