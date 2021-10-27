
layer = layer_get_id("TileFadeObjects");

for(var i = 0; i < 4; i++)
{
	var lay = layer_get_id("Tiles_fade"+string(i));
	if(layer_exists(lay) && layer_get_visible(lay))
	{
		layer_set_visible(lay,false);
	}
}