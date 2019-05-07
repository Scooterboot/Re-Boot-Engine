/// @description Insert description here
// You can write your code in this editor
var a = layer_get_all();
for(var i = 0; i < array_length_1d(a); i++)
{
	if(string_count("Tiles_fg",layer_get_name(a[i])) > 0)
	{
		layer_set_visible(a[i],false);
	}
}