/// @description Lava Movement
event_inherited();

if(global.GamePaused())
{
	exit;
}

if(velX != 0)
{
	posX = scr_wrap(posX+velX,-spriteW/2,spriteW/2);
}

if(scr_WithinCamRange(-1,-1,64))
{
	if(!audio_is_playing(ambSnd[0]) && !audio_is_playing(ambSnd[1]) && !audio_is_playing(ambSnd[2]))
	{
		audio_play_sound(ambSnd[choose(0,1,2)],0,false);
	}
}
