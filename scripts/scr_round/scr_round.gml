/// @description scr_round(x)
/// @param x
var val = argument0;
return (val + (abs(frac(val)) >= 0.5)*sign(val) - frac(val));
