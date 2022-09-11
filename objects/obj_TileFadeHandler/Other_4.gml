
layer = layer_get_id("TileFadeObjects");

/*for(var i = 0; i < 4; i++)
{
	var lay = layer_get_id("Tiles_fade"+string(i));
	if(layer_exists(lay) && layer_get_visible(lay))
	{
		layer_set_visible(lay,false);
	}
}*/
tileLayers = scr_GetLayersFromString("Tiles_fade");
for(var i = 0; i < array_length(tileLayers); i++)
{
	layer_set_visible(tileLayers[i],false);
}