/// @description Lava Movement

if(global.GamePaused())
{
	exit;
}

if(moveY)
{
	if(abs(bobSpeed) >= bobBtm)
	{
		bobAcc *= -1;
	}
	bobSpeed += bobAcc;
	y += bobSpeed;
	
	image_yscale = scr_round(bottom-y + 1) / sprite_get_height(sprite_index);
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