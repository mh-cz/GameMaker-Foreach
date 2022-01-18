# GameMaker Foreach
A stackable foreach loop for arrays, lists, maps, structs, grids, strings and number ranges

This foreach was made using MACROS and not using FUNCTIONS so you don't have to pass variables like arguments. Just type them directly. On the other hand it will reserve these keywords: `foreach, in, as_array, as_list, as_map, as_struct, as_grid, as_string, as_range` and one global variable `fed`

Just call `foreach_init()` once when the game starts and you're good to go

It's basically just a for loop with extra steps so you can also use `continue;` and `break;`

DO NOT create the index/key/value manually. 
These will get created at runtime so it should be saying something like "this variable is used only once". (see the last exemple code)

# How to use
```
usage:
    foreach <args> in <data> as_<data_type> 

possible args:
     ["val"] (or just "val")   	 	-returns only values
     ["val", step]     			-returns values and uses custom counter
     ["val", step, startfrom]     	-returns values and uses custom counter and custom start position
     ["key", "val"]     		-returns keys and values
     ["key", "val", step]     		-returns keys, values and uses custom counter
     ["key", "val", step, startfrom]    -returns keys, values and uses custom counter and start position

     "key", "val"     (string)
          - you can name these variables as you want
               (choose unused variable names that do not exists yet)
	  - if both are used:
		  - the first string will always return index/key
		  - the second string will always return value
          - "key":
               - list, array, string 	returns index (real)
	       - map, struct 		returns keys (string)
	       - grid 			returns [xpos, ypos] (array of reals)

     step, startfrom     (real)
          - both optional
          - step is what is added to the values used for iteration (i += step)
          - startfrom is where the iterator starts (i = startfrom)

 possible data types:
     as_array, as_list, as_map, as_struct, as_grid, as_string, as_range

 note:
     the system is using a single global variable "fed" (ForEachData)
          you can rename it, just hit ctrl+f in the script and replace it with whatever name you want
     
     there is also a fed.set(val) function for lazy typers so you can simply change the value in the data while looping

     when you type the args name it should be saying that the variable is used only once
     which is fine because the variable will be created at runtime
     DO NOT create these string args variables using the "var" keyword because it's not possible to overwrite variables created like this
     
     it's still just a loop so you can use break; and continue;
```
# Examples
```
var arr = ["Bob", "Julie", "John", "Mark"];

foreach "name" in arr as_array {
	show_debug_message(name);
}

/* >>
"Bob"
"Julie"
"John"
"Mark"
*/
```
```
var arr = ["Bob", "Julie", "John", "Mark"];

foreach ["index", "name"] in arr as_array {
	show_debug_message(string(index) + " " + string(name));
}

/* >>
"0 Bob"
"1 Julie"
"2 John"
"3 Mark"
*/
```
```
var arr = ["Bob", "Julie", "John", "Mark"];

foreach ["index", "name", 1, 2] in arr as_array {
	show_debug_message(string(index) + " " + string(name));
}

/* >>
"2 John"
"3 Mark"
*/
```
you can access any variable from the struct containing all the settings in the current loop
(see how the set function uses this)

```
fed.cs.<var>;
```
#### this foreach is stackable
also if you want to return only the key or index just leave the second string empty
```
var inventory = [
	{ weapon: "gun", ammo: 20 },
	{ weapon: "sword", ammo: 0 },
	{ weapon: "something_else", ammo: 500 },
];

foreach ["index", ""] in inventory as_array {
	foreach ["key", "info"] in inventory[index] as_struct {
		show_debug_message([index, info]);
	}
}
```
fed.set example
```
var arr = [1, 2, 3, 4];

foreach "num" in arr as_array {
	fed.set(num + 1);
}
// after foreach >> [2, 3, 4, 5]

// which is the same as
foreach ["index", "num"] in arr as_array {
	arr[@ index] = num + 1;
}
```
as_range
```
foreach "n" in 3 as_range {
	show_debug_message(n);
}

/* >>
0
1
2
*/
```
```
foreach "n" in [2, -2, 0.5] as_range {
	show_debug_message(n);
}

/* >>
2
1.5
1
0.5
0
-0.5
-1
-1.5
*/
```
### if you try to reuse an existing variable it will NOT overwrite the existing variable
### variable_instance_set() can't do that
###### this is the biggest problem with this foreach and idk how to solve it
```
var index = 100; // <<<<<<<<<<<< XXXXX

var arr = ["Bob", "Julie", "John", "Mark"];

foreach ["index", "name"] in arr as_array {
	show_debug_message(string(index) + " " + string(name));
}

/* >>
"100 Bob"
"100 Julie"
"100 John"
"100 Mark"
*/
```
you can reuse a variable created by another foreach tho
```
foreach ["index", "name"] in arr as_array {
	show_debug_message(string(index) + " " + string(name));
}

foreach ["index", "char"] in str as_string {
	show_debug_message(string(index) + " " + string(char));
}
```
