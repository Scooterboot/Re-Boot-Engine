/// @description 

var ww = global.resWidth,
	hh = global.resHeight;

surface_set_target(obj_Display.surfUI);
UIBlend();

if(room == rm_MainMenu)
{
	if(state == MMState.TitleIntro)
	{
		// stuff
	}

	if(state == MMState.Title || state == MMState.MainMenu)
	{
		draw_sprite_ext(sprt_Title, 0, (ww/2), (hh/2) - 81, 1, 1, 0, c_white, titleAlpha);
	}

	if(state == MMState.Title)
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

	if(state == MMState.MainMenu)
	{
		if(instance_exists(mainMenuPanel))
		{
			mainMenuPanel.alpha = min(mainMenuPanel.alpha+0.15,1);
			for(var i = 0; i < ds_list_size(mainMenuPanel.buttonList); i++)
			{
				var btn = mainMenuPanel.buttonList[| i];
				btn.DrawButton(btn.GetX(),btn.GetY());
			}
		}
	}

	if(state == MMState.FileMenu)
	{
		draw_set_color(c_black);
		draw_set_alpha(1);
		draw_rectangle(-1,-1,ww+1,hh+1,false);
		draw_sprite_ext(bg_Zebes, 0, ww/2, hh/2, 1, 1, 0,c_white,1);
	
		if(instance_exists(copyFilePanel))
		{
			for(var i = 0; i < ds_list_size(copyFilePanel.buttonList); i++)
			{
				var btn = copyFilePanel.buttonList[| i];
				btn.DrawButton(btn.GetX(),btn.GetY());
			}
		}
		else
		{
			if(instance_exists(fileMenuPanel))
			{
				for(var i = 0; i < ds_list_size(fileMenuPanel.buttonList); i++)
				{
					var btn = fileMenuPanel.buttonList[| i];
					btn.DrawButton(btn.GetX(),btn.GetY());
				}
			}
			if(subState == MMSubState.FileSelected && instance_exists(selectedFilePanel))
			{
				for(var i = 0; i < ds_list_size(selectedFilePanel.buttonList); i++)
				{
					var btn = selectedFilePanel.buttonList[| i];
					btn.DrawButton(btn.GetX(),btn.GetY());
				}
			}
		}
		
		if(subState == MMSubState.ConfirmCopy || subState == MMSubState.ConfirmDelete)
		{
			draw_set_color(c_black);
			draw_set_alpha(0.5);
			draw_rectangle(-1,-1,ww+1,hh+1,false);
			draw_set_alpha(1);
			
			draw_set_font(fnt_Menu2);
			draw_set_align(fa_center,fa_bottom);
			var str = "";
			if(instance_exists(confirmCopyPanel))
			{
				str = confirmCopyPanel.text;
			}
			if(instance_exists(confirmDeletePanel))
			{
				str = confirmDeletePanel.text;
			}
			var _sx = ww/2,
				_sy = hh/2 - 8,
				_sw = string_width(str),
				_sh = string_height(str);
			
			draw_set_color(c_black);
			draw_set_alpha(0.75);
			draw_roundrect(_sx-_sw/2 -5, _sy-_sh -4, _sx+_sw/2 +3, _sy+20 +3, false);
			draw_set_color(c_lime);
			draw_roundrect(_sx-_sw/2 -5, _sy-_sh -4, _sx+_sw/2 +3, _sy+20 +3, true);
			
			draw_set_alpha(1);
			draw_set_color(c_black);
			draw_text(_sx+1,_sy+1,str);
			draw_set_color(c_white);
			draw_text(_sx,_sy,str);
			
			if(instance_exists(confirmCopyPanel))
			{
				for(var i = 0; i < ds_list_size(confirmCopyPanel.buttonList); i++)
				{
					var btn = confirmCopyPanel.buttonList[| i];
					btn.DrawButton(btn.GetX(),btn.GetY());
				}
			}
			if(instance_exists(confirmDeletePanel))
			{
				for(var i = 0; i < ds_list_size(confirmDeletePanel.buttonList); i++)
				{
					var btn = confirmDeletePanel.buttonList[| i];
					btn.DrawButton(btn.GetX(),btn.GetY());
				}
			}
		}
	}

	if(state != MMState.TitleIntro && state != MMState.Title)
	{
		buttonTipY = min(buttonTipY+1,buttonTipScrib.get_height());
	}
	else
	{
		buttonTipY = 0;
	}
	if(buttonTipY > 0)
	{
		var bTip = buttonTip[2];
		if(subState != MMSubState.None)
		{
			bTip = buttonTip[3];
		}
		buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1];
		if(state == MMState.FileMenu)
		{
			buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1]+"   ${menuCancelButton} - "+bTip;
		}
		var str = obj_UIHandler.InsertIconsIntoString(buttonTipString);
		if(buttonTipScrib.get_text() != str)
		{
			buttonTipScrib.overwrite(str);
		}
	
		var _height = buttonTipScrib.get_height();
		var _yoff = _height - buttonTipY;

		draw_set_alpha(0.75);
		draw_set_color(c_black);
		draw_rectangle(-32, hh-_height + _yoff, ww+31, hh + _yoff, false);
		draw_set_alpha(1);
		draw_set_color(c_white);

		var col2 = make_color_rgb(26,108,0);
		gpu_set_blendmode(bm_add);
		draw_rectangle_color(-32, hh-_height + _yoff, (ww/2)-1, hh + _yoff, c_black,col2,col2,c_black, false);
		draw_rectangle_color((ww/2), hh-_height + _yoff, ww+31, hh + _yoff, col2,c_black,c_black,col2, false);
		UIBlend();
	
		var tipx = ww/2,
			tipy = hh-4;
	
		buttonTipScrib.blend(c_black,1);
		buttonTipScrib.draw(tipx+1,tipy+1 + _yoff);
		buttonTipScrib.blend(c_white,1);
		buttonTipScrib.draw(tipx,tipy + _yoff);

		draw_set_font(fnt_GUI);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);

		draw_set_alpha(1);
		draw_set_color(c_black);
	}
	
	//debug
	/*
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(fnt_GUI_Small);
	draw_set_align(fa_left,fa_top);
	draw_text(24,24,"state: "+string(state));
	draw_text(24,24 + 10,"subState: "+string(subState));
	draw_text(24,24 + 20,"mainMenuPanel: "+string(instance_exists(mainMenuPanel)));
	draw_text(24,24 + 30,"fileMenuPanel: "+string(instance_exists(fileMenuPanel)));
	draw_text(24,24 + 40,"selectedFilePanel: "+string(instance_exists(selectedFilePanel)));
	draw_text(24,24 + 50,"copyFilePanel: "+string(instance_exists(copyFilePanel)));
	*/
}

draw_set_color(c_black);
draw_set_alpha(min(screenFade,1));
draw_rectangle(-1,-1,ww+1,hh+1,false);
draw_set_alpha(1);

gpu_set_blendmode(bm_normal);
surface_reset_target();