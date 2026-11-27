/// @description 

var flag = false;
with(obj_UI_SettingsMenu_Parent)
{
	if(screenFade >= 1)
	{
		flag = true;
	}
}
if(room == rm_MainMenu && (!instance_exists(obj_UI_SettingsMenu_Parent) || !flag))
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	if(state == UI_MMState.SettingsMenu)
	{
		BentoDrawClear(, 1);
		draw_sprite_ext(bg_Space, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
	}
	if(state == UI_MMState.FileMenu)
	{
		BentoDrawClear(, 1);
		draw_sprite_ext(bg_Zebes, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
	}
	
	BentoEnvironmentDraw(environment);
	
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
	
	if(state == UI_MMState.MainMenu)
	{
		var _fSprt = sprt_UI_Footer2,
			_fH = sprite_get_height(_fSprt);
		footerY = min(footerY+1, _fH);
		
		var cw = 24;
		draw_sprite_stretched_ext(_fSprt,0, (ww-global.ogResWidth)/2-cw, hh-footerY, global.ogResWidth+cw*2, _fH, c_white,1);
		
		var _tipStr = footerText[0];
		var _scrib = scribble(_tipStr)
			.starting_format(font_get_name(fnt_GUI_Small),c_white)
			.align(fa_center,fa_top);
		draw_scribble_shadow(_scrib, scr_round(ww/2), scr_round(hh-footerY+4));
	}
	else if(state == UI_MMState.SettingsMenu || state == UI_MMState.FileMenu)
	{
		var _headStr = headerText[0],
			_footStr = footerText[1];
		
		if(state == UI_MMState.FileMenu)
		{
			_headStr = headerText[1];
			if(subState == UI_MMSubState.FileCopy || subState == UI_MMSubState.ConfirmCopy)
			{
				_headStr = headerText[2];
			}
			if(subState != UI_MMSubState.None)
			{
				_footStr = footerText[2];
			}
		}
		
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
	}
	else
	{
		footerY = 0;
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
