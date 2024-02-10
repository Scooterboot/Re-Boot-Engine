/// @description Set pos and draw mouse

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight;

var screenScale = global.screenScale;
if(global.screenScale == 0)
{
	screenScale = min(max(window_get_width()/ww,1),max(window_get_height()/hh,1));
}

posX = (mouse_x - xx) * (window_get_width() / (ww*screenScale)) - global.screenX/screenScale;
posY = (mouse_y - yy) * (window_get_height() / (hh*screenScale)) - global.screenY/screenScale;

x = posX + xx;
y = posY + yy;

hide = true; //(room != rm_MainMenu && !obj_PauseMenu.pause);

if(!hide)
{
	image_alpha = min(image_alpha+0.1,1);
}
else
{
	image_alpha = max(image_alpha-0.1,0);
}

var sprt = sprt_MouseCursor;
draw_sprite_ext(sprt,0,x,y,1,1,0,make_color_rgb(51,109,174),image_alpha);

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
	
	gpu_set_blendmode(bm_add);
	draw_surface_ext(mouseGlowSurf,x,y,1,1,0,c_white,image_alpha);
	gpu_set_blendmode(bm_normal);
}