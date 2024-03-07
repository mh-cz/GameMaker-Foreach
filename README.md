# GameMaker Foreach v3.0.1

A foreach loop for **arrays**, **lists**, **maps**, **structs**, **grids**, **strings** and **number ranges**.  
This foreach was made using macros so you don't have to pass variables like arguments. You can access them inside of the loop directly.  
Reserved keywords: `foreach`, `foreach_rev`, `into`, `exec`, `as_list`, `as_grid`, `as_map`, `fe`, `fe_break`, `fe_continue`, `fe_return`, `global._FE_*`

### Changes 
[v3.0.1] Renamed `invar` to `into`  
It makes slightly more sense  

[v3.0.0] A complete refractor  
+ managed to speed it up by about 40%
+ no more warnings
+ DATA and VAR had to SWITCH PLACES

### Syntax
`foreach <data> into <var> exec`  
  
reversed loop:  
`foreach_rev <data> into <var> exec`  
  
+ `<var>` - an unused variable name to use
+ `<data>` - any supported data  
Only data that dont use `keys` as indexes can be reversed  

DS datatypes require a specification:  
```
foreach <some_ds_map> as_map into v exec
foreach <some_ds_list> as_list into v exec
foreach <some_ds_grid> as_grid into v exec
```
  
####
The macro variable `fe` contains these variables of the current loop body:  
- index `fe.i` for array, list, grid, number range, string
- key `fe.key` for map, struct
- position `fe.xpos`, `fe.ypos` for grid
- write function `fe.set(val)` for anything but string and number range since those aren't references  
  
####
To return from a function from within the loop use `fe_return(val, [depth=1]);`  
To break the loop use `fe_break;`  
To continue the loop use `fe_continue;`  
  
While using `fe_return` you need to pay attention how "deep" the return is. If `fe_return` is called in a nested fe loop you have to specify how many fe loops to break using the depth parameter otherwise the stack doesn't get cleared correctly and it will cause unpredictable behaviour. (tbh I wouldn't return from within fe loops at all)  
  
####
Still a one-liner
```
foreach xxx into v1 exec
  foreach xxx into v2 exec
    foreach xxx into v3 exec
      ...
```

## Examples
```
var st = { one: 1, two: 2 };

foreach st into v exec
  show_debug_message(fe.key + ": " + string(v));
```
```
var arr = [1,2,3,4,5,6];

foreach_rev arr into v exec
  show_debug_message(string(fe.i) + ": " + string(v));
```
```
var m = ds_map_create();
ds_map_add(m, "one", 1);
ds_map_add(m, "two", 2);

foreach m as_map into v exec
  show_debug_message(fe.key + ": " + string(v));
```
Range  
+ 1 param: from = 0, to = `p1`, step = 1  
+ 2 params: from = `p1`, to = `p2`, step = 1  
+ 3 params: from = `p1`, to = `p2`, step = `p3`  
  
```
foreach 5 into v exec
  show_debug_message(v);
```
```
foreach -5, 5 into v exec
  show_debug_message(v);
```
```
foreach -5, 5, 0.5 into v exec
  show_debug_message(v);
```
