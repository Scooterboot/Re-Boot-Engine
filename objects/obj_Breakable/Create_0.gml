/// @description Initialize
event_inherited();
respawnTime = 300;
image_speed = 0;
image_index = 1;

snd = snd_BlockBreakSoft;
respawnSprt = sprt_BlockBreak;

visible = true;
tileLayers = scr_GetLayersFromString("Tiles_fg", "Tiles_fade");
for(var i = 0; i < array_length(tileLayers); i++)
{
	var map_id = layer_tilemap_get_id(tileLayers[i]);
	if(layer_tilemap_exists(tileLayers[i],map_id))
	{
		var data = tilemap_get_at_pixel(map_id,bbox_left+8,bbox_top+8) & tile_index_mask;
		if(!tile_get_empty(data))
		{
			visible = false;
			break;
		}
	}
}

hiddenDestroy = false;

function RevealTile()
{
	for(var i = 0; i < array_length(tileLayers); i++)
	{
		var map_id = layer_tilemap_get_id(tileLayers[i]);
		if(layer_tilemap_exists(tileLayers[i],map_id))
		{
			for(var k = 0; k < image_xscale; k++)
			{
				for(var l = 0; l < image_yscale; l++)
				{
					var ix = bbox_left+8+16*k,
						iy = bbox_top+8+16*l;
					var data = tilemap_get_at_pixel(map_id,ix,iy) & tile_index_mask;
					if(!tile_get_empty(data))
					{
						data = tile_set_empty(data);
						tilemap_set_at_pixel(map_id,data,ix,iy);
					}
				}
			}
		}
	}
}

extSprt = noone;

function DrawBreakable(_x,_y,_index, _extIndex = 0)
{
	if(extSprt != noone && _index > 0)
	{
		draw_sprite_ext(extSprt,_extIndex,_x,_y,image_xscale/2,image_yscale/2,image_angle,c_white,1);
	}
	else
	{
		for(var i = min(image_xscale,0); i < max(image_xscale,0); i++)
		{
		    for(var j = min(image_yscale,0); j < max(image_yscale,0); j++)
		    {
				var k = i,
					l = j;
				if(image_xscale < 0)
				{
					k = i+1;
				}
				if(image_yscale < 0)
				{
					l = j+1;
				}
				var bx = _x+lengthdir_x(16*k,image_angle)+lengthdir_y(-16*l,image_angle),
					by = _y+lengthdir_x(16*l,image_angle)+lengthdir_y(16*k,image_angle);
				draw_sprite_ext(sprite_index,_index,bx,by,sign(image_xscale),sign(image_yscale),image_angle,c_white,1);
		    }
		}
	}
}