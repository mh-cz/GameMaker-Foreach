# GameMaker Foreach v2
Redone from scratch

A stackable foreach loop for arrays, lists, maps, structs, grids, strings and number ranges.

This foreach was made using macros so you don't have to pass variables like arguments. You can access them inside of the loop directly. 

Reserved keywords: `feach, in, as_array, as_list, as_map, as_struct, as_grid, as_string, as_range` + global variable `fe`.

### Changelog
[2.0.0]
- Data is returned inside a global struct `fe` so it can be called in anonymous functions
- You can no longer only use variable names that don't exist yet
- You only type the return value name. Iterator/Key names are created automatically
- It's a true one-liner now so you can call it without surrounding it with brackets
- Map function is simpler to use
- The code is not a fking mess anymore

### How to use it
Call `foreach_init()` once when the game starts and you're good to go.

### Syntax
`feach "<VALUE_NAME>", <START_FROM>, <STEP> in <DATA> as_<DATA_TYPE>`

- VALUE_NAME - string, required
- START_FROM - real, optional
- STEP - real, optional
- DATA - any supported data
- DATA_TYPE - type of the entered data

