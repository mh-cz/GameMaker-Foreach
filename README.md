# GameMaker Foreach v2
Redone from scratch

A stackable foreach loop for arrays, lists, maps, structs, grids, strings and number ranges.

This foreach was made using macros so you don't have to pass variables like arguments. You can access them directly. 

Reserved keywords: `feach, in, as_array, as_list, as_map, as_struct, as_grid, as_string, as_range` + global variable `fe`.

### What changed
- Data is returned inside a global struct `fe` so it can be called in anonymous functions
- You only type the return value name. Iterator/Key names are created automatically
- It's a true one-liner now so you can call it without surrounding it with brackets
- The code is not a fking mess anymore

### How to use it
Call `foreach_init()` once when the game starts and you're good to go.

### Syntax
`feach "<VALUE_NAME>", <START_FROM>*, <STEP>* in <DATA> as_<DATA_TYPE>`

- values START_FROM and STEP are optional
