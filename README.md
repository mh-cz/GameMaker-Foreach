# GameMaker Foreach v3.0.0

A foreach loop for **arrays**, **lists**, **maps**, **structs**, **grids**, **strings** and **number ranges**.  
This foreach was made using macros so you don't have to pass variables like arguments. You can access them inside of the loop directly.  
Reserved keywords: `foreach`, `foreach_rev`, `into`, `exec`, `as_list`, `as_grid`, `as_map`, `fe`, `fe_break`, `fe_continue`, `fe_return`, `global._FE_*`

### Changes 
[v3.0.1] Renamed `invar` to `into`

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

DS datatypes require a specification:  
```
foreach <some_ds_map> as_map into v exec
foreach <some_ds_list> as_list into v exec
foreach <some_ds_grid> as_grid into v exec
```
  
####
The macro variable `fe` contains these variables:  
- index `fe.i` (array, list, number range, string)
- key `fe.key` (map, struct)
- position `fe.xpos`, `fe.ypos` (grid)
- write function `fe.set(val)` (anything but string and number range)
  
####
To return from a function from within the loop use `fe_return(val, [depth=1]);`  
To break the loop use `fe_break;`  
To continue the loop use `fe_continue;`  
  
While using `fe_return` you need to pay attention how "deep" the return is. If `fe_return` is called in a nested fe loop you have to specify how many fe loops to break using the depth parameter otherwise the stack doesn't get cleared right and it will cause unpredictable behaviour.  
  
