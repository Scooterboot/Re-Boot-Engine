
layer = layer_get_id("TileFadeObjects");

tileLayers = scr_GetLayersFromString("Tiles_fade");
for(var i = 0; i < array_length(tileLayers); i++)
{
	layer_set_visible(tileLayers[i],false);
}