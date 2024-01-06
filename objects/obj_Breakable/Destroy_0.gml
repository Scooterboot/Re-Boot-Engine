/// @description Create Respawn Object

if(!hiddenDestroy)
{
	if((global.breakSndCounter <= 0) && !audio_is_playing(snd_PowerBombExplode))
	{
	    audio_stop_sound(snd);
	    audio_play_sound(snd,0,false);
	    global.breakSndCounter = 5;
	}
}

if(!visible)
{
	RevealTile();
}

//if(respawnTime > 0)
//{
    var re = instance_create_layer(x,y,layer,obj_BlockRespawn);
    re.sprite_index = respawnSprt;
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
//}