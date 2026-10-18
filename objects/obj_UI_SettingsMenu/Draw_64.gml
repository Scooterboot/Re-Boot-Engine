
if(activeState == UI_ActiveState.Active || activeState == UI_ActiveState.Deactivating)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	var _headStr = headerText[state],
		_footStr = footerText[0];
	
	var cw = 24;
	var hh2 = sprite_get_height(sprt_UI_Header2);
	draw_sprite_stretched_ext(sprt_UI_Header2,0, (ww-global.ogResWidth)/2-cw,0, global.ogResWidth+cw*2, hh2, c_white,1);
	
	var _scrib = scribble(_headStr)
		.starting_format(font_get_name(fnt_Menu),c_white)
		.align(fa_center,fa_top);
	
	draw_scribble_shadow(_scrib, scr_round(ww/2), 1);
	
	hh2 = sprite_get_height(sprt_UI_Footer2);
	draw_sprite_stretched_ext(sprt_UI_Footer2,0, (ww-global.ogResWidth)/2-cw,hh-hh2, global.ogResWidth+cw*2, hh2, c_white,1);
	
	_scrib = scribble(_footStr)
	.starting_format(font_get_name(fnt_GUI_Small),c_white)
	.align(fa_center,fa_bottom);
	
	draw_scribble_shadow(_scrib, scr_round(ww/2), scr_round(hh));
	
	if(screenFade > 0)
	{
		BentoDrawClear(, screenFade);
	}
	
	bm_reset();
	surface_reset_target();
}
else if(screenFade > 0)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	BentoDrawClear(, screenFade);
	
	bm_reset();
	surface_reset_target();
}
