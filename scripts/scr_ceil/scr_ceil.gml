/// @description scr_ceil(x)
/// @param x
function scr_ceil(argument0) {
	var val = argument0;
	return (val + (abs(frac(val)) > 0)*sign(val) - frac(val));



}
