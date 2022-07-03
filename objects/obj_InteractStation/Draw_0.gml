/// @description Anim

var animSpeed = 10;
if(activeDir != 0)
{
	var aFrame = 3;
	if(activeDir == -1)
	{
		aFrame = 4;
	}
	draw_sprite_ext(sprite_index,aFrame,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);
	animSpeed = 3;
}

if(!global.gamePaused)
{
	frameCounter++;
	if(frameCounter > animSpeed)
	{
		frame = scr_wrap(frame+1,0,3);
		frameCounter = 0;
	}
}

draw_sprite_ext(sprite_index,frame,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);