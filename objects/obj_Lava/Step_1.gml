/// @description Lava Movement

if(global.gamePaused)
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
	
	image_yscale = scr_ceil(bottom-y + 1) / sprite_get_height(sprite_index);
}

if(velX != 0)
{
	posX = scr_wrap(posX+velX,-spriteW/2,spriteW/2);
}

if(instance_exists(obj_Camera))
{
	var extraRng = 64,
		cam = obj_Camera;
	if(rectangle_in_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom, cam.x-extraRng,cam.y-extraRng,cam.x+global.resWidth+extraRng,cam.y+global.resHeight+extraRng) > 0)
	{
		if(!audio_is_playing(ambSnd[0]) && !audio_is_playing(ambSnd[1]) && !audio_is_playing(ambSnd[2]))
		{
			audio_play_sound(ambSnd[choose(0,1,2)],0,false);
		}
	}
}