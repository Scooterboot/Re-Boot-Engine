
function scr_DrawMouse(mouseX,mouseY)
{
	var cursorColor = make_color_rgb(51,109,174);
	draw_sprite_ext(sprt_MouseCursor,0,mouseX,mouseY,1,1,0,cursorColor,1);
	
	if(!surface_exists(cursorGlowSurf))
	{
		cursorGlowSurf = surface_create(11,15);
	}
	else
	{
		var xx = 1,
			yy = 1;
		surface_set_target(cursorGlowSurf);
		draw_clear_alpha(c_black,0);
		
		var sprt = sprt_MouseCursor;
		
		gpu_set_colorwriteenable(0,0,0,1);
		var height = 20;
		var totHeight = sprite_get_height(sprt)*2+(height*2);
		global.cursorGlow = scr_wrap(global.cursorGlow + 1, 0, totHeight);
		
		for(var i = -height; i < height; i++)
		{
			var ly = scr_wrap(yy + global.cursorGlow + i,0,totHeight),
				lx1 = xx - sprite_get_width(sprt)/2 - 4,
				lx2 = xx + sprite_get_width(sprt)/2 + 4;
			var ly2 = ly+lengthdir_y(lx2-lx1,22.5);
			
			draw_set_color(c_white);
			draw_set_alpha((1-(abs(i)/height))*0.75);
			draw_line(lx1,ly,lx2,ly2);
			
			//draw_set_color(c_black);
			draw_set_alpha(1);
		}
		gpu_set_colorwriteenable(1,1,1,0);
		draw_sprite_ext(sprt_MouseCursor,0,0,0,1,1,0,make_color_rgb(128,201,240),1);
		gpu_set_colorwriteenable(1,1,1,1);
		
		surface_reset_target();
		
		gpu_set_blendmode(bm_add);
		draw_surface_ext(cursorGlowSurf,mouseX,mouseY,1,1,0,c_white,1);
		gpu_set_blendmode(bm_normal);
	}
}