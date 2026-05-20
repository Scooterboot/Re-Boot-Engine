/* // Not using Bento yet, but will in the future
surface_set_target(obj_Display.surfUI);
bm_set_one();

BentoSystemDraw();

if(screenFade > 0)
{
	draw_set_color(c_black);
	draw_set_alpha(clamp(screenFade,0,1));
	draw_rectangle(-1,-1,global.resWidth+1,global.resHeight+1,false);
	draw_set_alpha(1);
	
	screenFade = 0;
}

bm_reset();
surface_reset_target();
*/