event_inherited();
activeState = UI_ActiveState.Active;

environment = BentoEnvironmentCreate("settings menu environment");
mainLayer = BentoLayerCreate("settings menu layer", environment);

surf = noone;
function DrawUIHeader(_headStr)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	var cw = 24;
	var hh2 = sprite_get_height(sprt_UI_Header2);
	draw_sprite_stretched_ext(sprt_UI_Header2,0, (ww-global.ogResWidth)/2-cw,0, global.ogResWidth+cw*2, hh2, c_white,1);
	
	var _scrib = scribble(_headStr)
		.starting_format(font_get_name(fnt_Menu),c_white)
		.align(fa_center,fa_top);
	
	draw_scribble_shadow(_scrib, scr_round(ww/2), 1);
}
function DrawUIFooter(_footStr)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	var cw = 24;
	var hh2 = sprite_get_height(sprt_UI_Footer2);
	draw_sprite_stretched_ext(sprt_UI_Footer2,0, (ww-global.ogResWidth)/2-cw,hh-hh2, global.ogResWidth+cw*2, hh2, c_white,1);
	
	var _scrib = scribble(_footStr)
	.starting_format(font_get_name(fnt_GUI_Small),c_white)
	.align(fa_center,fa_bottom);
	
	draw_scribble_shadow(_scrib, scr_round(ww/2), scr_round(hh));
}