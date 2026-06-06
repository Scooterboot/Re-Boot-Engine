/*var ww = global.resWidth,
	hh = global.resHeight;

if(activeState == UI_ActiveState.Active || activeState == UI_ActiveState.Deactivating)
{
	if(!surface_exists(surf))
	{
		surf = surface_create(ww,hh);
	}
	if(surface_exists(surf))
	{
		if(surface_get_width(surf) != ww || surface_get_height(surf) != hh)
		{
			surface_resize(surf, ww, hh);
		}
		
		surface_set_target(surf);
		bm_set_one();
		draw_sprite_tiled_ext(bg_Space,0, ww/2,hh/2, 1,1, c_white,1);
		
		if(state == UI_SMState.Default)
		{
			if(instance_exists(defaultPage))
			{
				defaultPage.DrawPage();
			}
		}
		if(state == UI_SMState.Display)
		{
			if(instance_exists(displayPage))
			{
				displayPage.DrawPage();
			}
		}
		if(state == UI_SMState.Audio)
		{
			
		}
		if(state == UI_SMState.Gameplay)
		{
			
		}
		if(state == UI_SMState.Keyboard)
		{
			if(instance_exists(kbBindPage))
			{
				kbBindPage.DrawPage();
			}
		}
		if(state == UI_SMState.Controller)
		{
			
		}
		
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
		
		bm_reset();
		/*if(state == UI_SMState.Display)
		{
			if(instance_exists(displayPage))
			{
				displayPage.DrawPage();
			}
		}
		if(state == UI_SMState.Audio)
		{
			
		}
		if(state == UI_SMState.Gameplay)
		{
			
		}
		if(state == UI_SMState.Controls)
		{
			
		}
		
		var cw = 24;
		var hh2 = sprite_get_height(sprt_UI_Header2);
		draw_sprite_stretched_ext(sprt_UI_Header2,0, (ww-global.ogResWidth)/2-cw,0, global.ogResWidth+cw*2, hh2, c_white,1);
		if(instance_exists(headerPage))
		{
			headerPage.DrawPage();
		}
		
		hh2 = sprite_get_height(sprt_UI_Footer2);
		draw_sprite_stretched_ext(sprt_UI_Footer2,0, (ww-global.ogResWidth)/2-cw,hh-hh2, global.ogResWidth+cw*2, hh2, c_white,1);
		//
		* /
		surface_reset_target();
	}
}
else if(surface_exists(surf))
{
	surface_free(surf);
}

surface_set_target(obj_Display.surfUI);
bm_set_one();

if(surface_exists(surf) && (activeState == UI_ActiveState.Active || activeState == UI_ActiveState.Deactivating))
{
	draw_surface_ext(surf, 0,0, 1,1,0, c_white,1);
}

draw_set_color(c_black);
draw_set_alpha(min(screenFade,1));
draw_rectangle(-1,-1,ww+1,hh+1,false);
draw_set_alpha(1);

bm_reset();
surface_reset_target();
*/