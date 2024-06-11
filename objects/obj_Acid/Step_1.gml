/// @description Acid Movement

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