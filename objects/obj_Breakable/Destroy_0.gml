/// @description Create Respawn Object
if((global.breakSndCounter <= 0) && !audio_is_playing(snd_PowerBombExplode))
{
    audio_stop_sound(snd);
    audio_play_sound(snd,0,false);
    global.breakSndCounter = 5;
}

if(!visible)
{
	for(var i = 0; i < 4; i++)
	{
		var lay = layer_get_id("Tiles_fg"+string(i));
		if(layer_exists(lay))
		{
			var map_id = layer_tilemap_get_id(lay);
			var data = tilemap_get_at_pixel(map_id,x,y) & tile_index_mask;
			if(!tile_get_empty(data))
			{
				data = tile_set_empty(data);
				tilemap_set_at_pixel(map_id,data,x,y);
			}
		}
	}
}

part_particles_create(obj_Particles.partSystemD,x,y,obj_Particles.blockBreak[breakType],1);

if(respawnTime > 0)
{
    var re = instance_create_layer(x,y,layer,obj_BlockRespawn);
    re.sprite_index = respawnSprt;
    re.breakType = breakType;
    re.blockIndex = object_index;
    re.respawnTime = respawnTime;
    re.initialTime = respawnTime;
    re.image_xscale = image_xscale;
    re.image_yscale = image_yscale;
    if(object_index == obj_ChainBlock)
    {
        re.right = right;
        re.left = left;
        re.up = up;
        re.down = down;
        re.upright = upright;
        re.upleft = upleft;
        re.downright = downright;
        re.downleft = downleft;
    }
}