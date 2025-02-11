/// @description Set pos and draw mouse

if(!hide)
{
	image_alpha = min(image_alpha+0.1,1);
}
else
{
	image_alpha = max(image_alpha-0.05,0);
}

var sprt = sprt_UI_MouseCursor;

surface_set_target(obj_Display.surfUI);
draw_sprite_ext(sprt,0,x,y,1,1,0,make_color_rgb(51,109,174),image_alpha);
surface_reset_target();

if(!surface_exists(mouseGlowSurf))
{
	mouseGlowSurf = surface_create(11,15);
}
else
{
	var _xx = 1,
		_yy = 1;
	surface_set_target(mouseGlowSurf);
	draw_clear_alpha(c_black,0);
	
	gpu_set_colorwriteenable(0,0,0,1);
	var height = 20;
	var totHeight = sprite_get_height(sprt)*2+(height*2);
	mouseGlow = scr_wrap(mouseGlow + 1, 0, totHeight);
	
	for(var i = -height; i < height; i++)
	{
		var ly = scr_wrap(_yy + mouseGlow + i,0,totHeight),
			lx1 = _xx - sprite_get_width(sprt)/2 - 4,
			lx2 = _xx + sprite_get_width(sprt)/2 + 4;
		var ly2 = ly+lengthdir_y(lx2-lx1,22.5);
		
		draw_set_color(c_white);
		draw_set_alpha((1-(abs(i)/height))*0.75);
		draw_line(lx1,ly,lx2,ly2);
		
		//draw_set_color(c_black);
		draw_set_alpha(1);
	}
	gpu_set_colorwriteenable(1,1,1,0);
	draw_sprite_ext(sprt,0,0,0,1,1,0,make_color_rgb(128,201,240),1);
	gpu_set_colorwriteenable(1,1,1,1);
	
	surface_reset_target();
	
	surface_set_target(obj_Display.surfUI);
	gpu_set_blendmode(bm_add);
	gpu_set_colorwriteenable(1,1,1,0);
	draw_surface_ext(mouseGlowSurf,x,y,1,1,0,c_white,image_alpha);
	gpu_set_colorwriteenable(1,1,1,1);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
}