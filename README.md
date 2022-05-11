# GameMaker Foreach v2.0.2

A stackable foreach loop for arrays, lists, maps, structs, grids, strings and number ranges.

This foreach was made using macros so you don't have to pass variables like arguments. You can access them inside of the loop directly. 

Reserved keywords: `Foreach, Feach, inAarray, inInvArray inList, inInvList, inMap, inStruct, inGrid, inInvGrid, inString, inInvString, inRange, Loop` + global variable `FEDATA`.

### Changelog
[v2.0.2] Speeed
+ Up to 3x faster than the previous version
+ Syntax update - the `value` is now an actual variable instead of being stored in a global struct

### How to use it
Call `foreach_init()` once when the game starts and you're good to go

### Syntax
`Feach <var> inData <data> Run`

- `var` - a variable to use (will overwrite it if already exists)
- `data` - any supported datatype

####
You can use `break` and `continue`
####
The keyword `Loop` contains the current loop data like the current index (`Loop.i`), the current key (`Loop.key`) or the map function (`Loop.map(x)`)
###
Note: `Feach` is just shortened `Foreach` and you can choose the one you prefer

## Examples
Array - return value
```
var arr = [1, 2, 3, 4];

Feach v inArray arr Run
	show_debug_message(fe.v);
 
> 1
> 2
> 3
> 4
```
Array - return index and value
```
var arr = ["a","b","c","d"];

Feach v inArray arr Run
	show_debug_message(string(Loop.i) + ", " + string(v));
 
> 0, a
> 1, b
> 2, c
> 3, d
```
Array - simple map
```
var arr = [1, 2, 3, 4];
var multip = 10;

Feach num inArray arr Run
	Loop.map(num * multip);

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

Feach v inList some_values Run {
	     if Loop.i == 1 Loop.map(-v);
	else if Loop.i == 2 Loop.map(sqr(v));
	else if Loop.i == 3 Loop.map(v + add);
}

// now return them
Feach v inList some_values Run
	show_debug_message(v);

> 1
> -2
> 9
> 14
```
Grid - store cell coordinate into each cell
```
var grd = ds_grid_create(3,3);

Feach v inGrid grd Run
	Loop.map([Loop.xpos, Loop.ypos]);

The grid now contains:
[0,0] [1,0] [2,0]
[0,1] [1,1] [2,1]
[0,2] [1,2] [2,2]
```
Struct
```
var animals = {
	dogs: 10,
	cats: 4,
	rats: 9,
	cows: 7,
	goats: 2,
};

Feach anim_count inStruct animals Run {
	if anim_count < 0 Loop.map(0);
	if Loop.key == "cats" Loop.map(100);
}

```
Number ranges (returned values written in a single line cuz it's long)
```
Feach v inRange 5 Run 
	show_debug_message(v);
	
> 0, 1, 2, 3, 4

Feach v inRange 2, 5 Run 
	show_debug_message(v);
	
> 2, 3, 4

Feach v inRange 2, -2 Run 
	show_debug_message(v);
	
> 2, 1, 0, -1

Feach v inRange 2, -2, 0.5 Run 
	show_debug_message(v);
	
> 2, 1.5, 1, 0.5, 0, -0.5, -1, -1.5
```
Stackable like any other loop
```
Feach v1 inArray some_arr Run
	Feach v2 inStruct v1 Run
		Feach v3 inRange -v2, v2 Run
			do_something(v3);

```
One-liner possibilities
```
if !is_array(data) {
	...
}
else Feach v inArray some_arr Run {
	...
}
```
