/// @description Acid Movement
event_inherited();

if(global.GamePaused())
{
	exit;
}

if(velX != 0)
{
	posX = scr_wrap(posX+velX,-spriteW/2,spriteW/2);
}
