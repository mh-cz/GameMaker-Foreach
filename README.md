# GameMaker Foreach v2.0.6

A foreach loop for **arrays**, **lists**, **maps**, **structs**, **grids**, **strings** and **number ranges**.  
This foreach was made using macros so you don't have to pass variables like arguments. You can access them inside of the loop directly.  
Reserved keywords: `foreach`, `in`, `in_reversed`, `exec`, `as_list`, `as_grid`, `as_map`, `fe` + global variable `FEDATA`

### Changes
[v2.0.6] Syntax update  
Removed temp local variables. All is now hidden inside `global.FEDATA`  
  
[v2.0.5] Syntax update  
The syntax is much simpler thanks to [Gamer-XP](https://github.com/Gamer-XP)   
  
### Syntax
`foreach <var> in <data> exec`

+ `<var>` - variable
+ `<data>` - any supported data  

The only datatypes that require exact specifications are DS types
```
foreach v in <some_ds_map> as_map exec
foreach v in <some_ds_list> as_list exec
foreach v in <some_ds_grid> as_grid exec
```
  
####
The variable `fe` contains these variables:  
- index `fe.i` (array, list, number range, string)
- key `fe.key` (map, struct)
- position `fe.xpos`, `fe.ypos` (grid)
- write function `fe.set(val)` (anything but string and number range)
  
####
You can use `break` and `continue`  

## Examples
Array - return value
```
var arr = [1, 2, 3, 4];

foreach v in arr exec
	show_debug_message(v);
 
> 1
> 2
> 3
> 4
```
Array - return index and value
```
var arr = ["a","b","c","d"];

foreach v in arr exec
	show_debug_message(string(fe.i) + ", " + string(v));
 
> 0, a
> 1, b
> 2, c
> 3, d
```
Array - simple write
```
var arr = [1, 2, 3, 4];
var multip = 10;

foreach num in arr exec
	fe.set(num * multip);

The array now contains: [10, 20, 30, 40]
```
List - change some values inside
```
var lst = ds_list_create();
lst[| 0] = 1; 
lst[| 1] = 2;
lst[| 2] = 3; 
lst[| 3] = 4;

var add = 10;

foreach v in lst as_list exec {
	     if fe.i == 1 fe.set(-v);
	else if fe.i == 2 fe.set(sqr(v));
	else if fe.i == 3 fe.set(v + add);
}

// now return them
foreach v in lst as_list exec
	show_debug_message(v);

> 1
> -2
> 9
> 14
```
Grid - store cell coordinate into each cell
```
var grd = ds_grid_create(3,3);

foreach v in grd as_grid exec
	fe.set([fe.xpos, fe.ypos]);

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

foreach anim_count in animals exec {
	if anim_count < 0 fe.set(0);
	if fe.key == "cats" fe.set(100);
}

```
Number ranges
```
foreach v in 5 exec 
	show_debug_message(v);
	
> 0, 1, 2, 3, 4, 5

foreach v in 2, 5 exec 
	show_debug_message(v);
	
> 2, 3, 4, 5

foreach v in 2, -2 exec 
	show_debug_message(v);
	
> 2, 1, 0, -1, -2

foreach v in 2, -2, 0.5 exec 
	show_debug_message(v);
	
> 2, 1.5, 1, 0.5, 0, -0.5, -1, -1.5, -2
```
Stackable like any other loop
```
foreach v1 in some_arr exec
	foreach v2 in v1 exec
		foreach v3 in -v2, v2 exec
			do_something(v3);

```
One-liner
```
if !is_array(some_data) {
	...
}
else foreach v in some_data exec {
	...
}
```
