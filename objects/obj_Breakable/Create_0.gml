/// @description Initialize
respawnTime = 300;
image_speed = 0;
image_index = 1;

snd = snd_BlockBreakSoft;
respawnSprt = sprt_BlockBreak;
breakType = 0;

visible = true;
for(var i = 0; i < 4; i++)
{
	var lay = layer_get_id("Tiles_fg"+string(i));
	if(layer_exists(lay))
	{
		var map_id = layer_tilemap_get_id(lay);
		var data = tilemap_get_at_pixel(map_id,x,y) & tile_index_mask;
		if(!tile_get_empty(data))
		{
			visible = false;
			break;
		}
	}
}

revealTile = visible;