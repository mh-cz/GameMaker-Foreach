# GameMaker Foreach
Since GM doesn't have foreach I made one my own using macros

here's some examples

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
the foreach is stackable
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
// before foreach >> [1, 2, 3, 4]
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
### variable_instance_set simply can't do that
###### this is the biggest problem with this foreach and idk how to solve it

```
var index = 100;

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
