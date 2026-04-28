/// @description Create Respawn Object

if(!hiddenDestroy)
{
	if(snd != noone && (global.breakSndCounter <= 0) && !audio_is_playing(snd_PowerBombExplode))
	{
	    audio_stop_sound(snd);
	    audio_play_sound(snd,0,false);
	    global.breakSndCounter = 5;
	}
}

if(!visible)
{
	self.RevealTile();
}

if(respawnTime > 0 || !hiddenDestroy)
{
    var re = instance_create_layer(x,y,layer,obj_BlockRespawn);
    re.sprite_index = respawnSprt;
    re.blockIndex = object_index;
    re.respawnTime = respawnTime;
    re.initialTime = respawnTime;
    re.image_xscale = image_xscale;
    re.image_yscale = image_yscale;
	self.SetExtraRespawnVars(re);
	re.SetExtraRespawnVars = self.SetExtraRespawnVars;
}