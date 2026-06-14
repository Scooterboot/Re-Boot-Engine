/// @description 

if(room == rm_MainMenu && 
	obj_UI_SettingsMenu.activeState != UI_ActiveState.Active && 
	obj_UI_SettingsMenu.activeState != UI_ActiveState.Deactivating)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	if(state == UI_MMState.TitleIntro)
	{
		// stuff
	}
	if(state == UI_MMState.Title || state == UI_MMState.MainMenu)
	{
		draw_sprite_ext(sprt_Title, 0, (ww/2), (hh/2) - 81, 1, 1, 0, c_white, titleAlpha);
	}
	if(state == UI_MMState.Title)
	{
		if(pressStartAnim < 40)
		{
			var stX = scr_round(ww/2),
				stY = scr_round((hh/2)+80);
			
			draw_set_font(fnt_GUI);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			
			draw_set_alpha(titleAlpha);
			if(pressStartAnim%4 >= 2)
			{
				draw_set_color(c_ltgray);
				for(var i = 0; i < 8; i++)
				{
					draw_text(stX+scr_round(lengthdir_x(1.1,45*i)), stY+scr_round(lengthdir_y(1.1,45*i)), startString);
				}
				draw_set_alpha(titleAlpha*0.75);
			}
			else
			{
				draw_set_color(c_black);
				draw_text(stX+1, stY+1, startString);
			}
			
			draw_set_color(c_yellow);
			draw_text(stX, stY, startString);
			
			draw_set_color(c_white);
			draw_set_alpha(1);
		}
	}
	
	if(state == UI_MMState.FileMenu)
	{
		var _tipStr = headerText[0];
		if(subState == UI_MMSubState.FileCopy || subState == UI_MMSubState.ConfirmCopy)
		{
			_tipStr = headerText[1];
		}
		
		var _scrib = scribble(_tipStr)
			.starting_format(font_get_name(fnt_Menu),c_white)
			.align(fa_center,fa_top);
		
		draw_scribble_shadow(_scrib, scr_round(ww/2), 1);
	}
	
	if(state != UI_MMState.TitleIntro && state != UI_MMState.Title)
	{
		footerY = min(footerY+1, 13);
	}
	else
	{
		footerY = 0;
	}
	if(footerY > 0)
	{
		var _fSprt = sprt_UI_Footer,
			_fW = sprite_get_width(_fSprt),
			_fH = sprite_get_height(_fSprt);
		draw_sprite_ext(_fSprt,0, ww/2, hh-footerY, global.wideResWidth/_fW,footerY/_fH,0, c_white,1);
		
		var _tipStr = footerText[0];
		if(state == UI_MMState.FileMenu)
		{
			_tipStr = footerText[1];
		}
		if(subState != UI_MMSubState.None)
		{
			_tipStr = footerText[2];
		}
		
		var _scrib = scribble(_tipStr)
			.starting_format(font_get_name(fnt_GUI_Small),c_white)
			.align(fa_center,fa_top);
		
		draw_scribble_shadow(_scrib, scr_round(ww/2), scr_round(hh-footerY+4));
	}
	
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
