/// @description 

if(shutterH > 0)
{
	for(var i = shutterH; i >= 0; i -= 16)
	{
		var sh = i;
		var sX = x+lengthdir_x(sh,image_angle-90),
			sY = y+lengthdir_y(sh,image_angle-90);
		var index = 1;
		if(i >= shutterH)
		{
			index = 2;
		}
		draw_sprite_ext(sprt_Shutter,index,sX,sY,1,1,image_angle,image_blend,image_alpha);
	}
}

frame = 1;
if(state == ShutterState.Closing || state == ShutterState.Opening)
{
	frame = 2;
}

draw_sprite_ext(sprite_index,frame,x,y,1,1,image_angle,image_blend,image_alpha);
