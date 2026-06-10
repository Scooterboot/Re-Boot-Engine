
if(room == rm_MainMenu && 
	obj_UI_SettingsMenu.activeState != UI_ActiveState.Active && 
	obj_UI_SettingsMenu.activeState != UI_ActiveState.Deactivating)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	if(state == UI_MMState.FileMenu)
	{
		BentoDrawClear(, 1);
		draw_sprite_ext(bg_Zebes, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
	}
	
	bm_reset();
	surface_reset_target();
}
