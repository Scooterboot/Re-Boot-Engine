
if(activeState == UI_ActiveState.Active || activeState == UI_ActiveState.Deactivating)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	draw_sprite_tiled_ext(bg_Space,0, ww/2,hh/2, 1,1, c_white,1);
	
	bm_reset();
	surface_reset_target();
}
