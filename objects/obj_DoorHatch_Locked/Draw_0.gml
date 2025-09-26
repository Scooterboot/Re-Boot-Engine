
if(frame < 4)
{
	var _frame = 0;
	if(frame > 0)
	{
		_frame = 4+frame;
	}
	else
	{
		_frame = lockFrame;
	}
	draw_sprite_ext(sprite_index,_frame,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);
	if(unlockAnim >= 3 && frame <= 0 && lockFrame >= 4)
	{
		draw_sprite_ext(sprite_index,8,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha);
	}
}