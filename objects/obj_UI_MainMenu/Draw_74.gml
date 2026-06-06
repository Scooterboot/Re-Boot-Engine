
if(room == rm_MainMenu)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	if(state == UI_MMState.FileMenu)
	{
		draw_set_color(c_black);
		draw_set_alpha(1);
		draw_rectangle(-1,-1,ww+1,hh+1,false);
		draw_sprite_ext(bg_Zebes, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
	}
	
	bm_reset();
	surface_reset_target();
}
