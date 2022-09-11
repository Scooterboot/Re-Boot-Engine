/// @description Create Respawn Object

if(!hiddenDestroy)
{
	if((global.breakSndCounter <= 0) && !audio_is_playing(snd_PowerBombExplode))
	{
	    audio_stop_sound(snd);
	    audio_play_sound(snd,0,false);
	    global.breakSndCounter = 5;
	}
	
	for(var k = 0; k < image_xscale; k++)
	{
		for(var l = 0; l < image_yscale; l++)
		{
			var ix = x+16*k,
				iy = y+16*l;
			part_particles_create(obj_Particles.partSystemD,ix,iy,obj_Particles.blockBreak[breakType],1);
		}
	}
}

if(!visible)
{
	RevealTile();
}

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