/// @description 
var ww = global.resWidth,
	hh = global.resHeight;

surface_set_target(obj_Display.surfUI);
bm_set_one();

if(room == rm_MainMenu)
{
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
			var stX = (ww/2),
				stY = (hh/2)+80;
	
			draw_set_font(fnt_GUI);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			if(pressStartAnim%6 >= 3)
			{
				draw_set_color(c_ltgray);
				draw_set_alpha(titleAlpha);
				for(var i = 0; i < 8; i++)
				{
					draw_text(scr_round(stX+lengthdir_x(1.1,45*i)),scr_round(stY+lengthdir_y(1.1,45*i)),startString);
				}
				draw_set_color(c_yellow);
				draw_set_alpha(titleAlpha*0.75);
				draw_text(scr_round(stX),scr_round(stY),startString);
			}
			else
			{
				scr_DrawOptionText(stX,stY,startString,c_yellow,titleAlpha,0,c_black,0);
			}
		}
	}
	if(state == UI_MMState.MainMenu)
	{
		if(instance_exists(mainMenuPage))
		{
			mainMenuPage.DrawPage();
		}
	}
	
	if(state == UI_MMState.FileMenu)
	{
		draw_set_color(c_black);
		draw_set_alpha(1);
		draw_rectangle(-1,-1,ww+1,hh+1,false);
		draw_sprite_ext(bg_Zebes, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
		
		if(instance_exists(copyFilePage))
		{
			copyFilePage.DrawPage();
		}
		else
		{
			if(instance_exists(fileMenuPage))
			{
				fileMenuPage.DrawPage();
			}
			if(subState == UI_MMSubState.FileSelected && instance_exists(selectedFilePage))
			{
				selectedFilePage.DrawPage();
			}
		}
		
		if(instance_exists(confirmCopyPage))
		{
			confirmCopyPage.DrawPage();
		}
		if(instance_exists(confirmDeletePage))
		{
			confirmDeletePage.DrawPage();
		}
	}
	
	var footerSprt = sprt_UI_Footer;
	if(state != UI_MMState.TitleIntro && state != UI_MMState.Title)
	{
		footerY = min(footerY+1, 12);
	}
	else
	{
		footerY = 0;
	}
	if(footerY > 0)
	{
		var _tipStr = footerString[0];
		if(state == UI_MMState.FileMenu)
		{
			_tipStr = footerString[1];
		}
		if(subState != UI_MMSubState.None)
		{
			_tipStr = footerString[2];
		}
		var str = obj_UI_Icons.InsertIconsIntoString(_tipStr);
		if(footerScrib.get_text() != str)
		{
			footerScrib.overwrite(str);
		}
	
		var _fSprt = sprt_UI_MainMenu_Footer,
			_fW = sprite_get_width(_fSprt),
			_fH = sprite_get_height(_fSprt);
		draw_sprite_ext(_fSprt,0, ww/2, hh-footerY, global.wideResWidth/_fW,footerY/_fH,0, c_white,1);
	
		var tipx = scr_round(ww/2),
			tipy = scr_round(hh-footerY+7);
	
		footerScrib.blend(c_black,1);
		footerScrib.draw(tipx+1,tipy+1);
		footerScrib.blend(c_white,1);
		footerScrib.draw(tipx,tipy);
	}
}

draw_set_color(c_black);
draw_set_alpha(min(screenFade,1));
draw_rectangle(-1,-1,ww+1,hh+1,false);
draw_set_alpha(1);

bm_reset();
surface_reset_target();
