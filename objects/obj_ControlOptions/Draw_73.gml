/// @description Draw

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight,
	alpha = screenFade;

if(room != rm_MainMenu)
{
	alpha = min(screenFade,obj_PauseMenu.pauseFade);
}

if(surface_exists(surf))
{
	surface_resize(surf,global.resWidth,global.resHeight);
	surface_set_target(surf);
	draw_clear_alpha(c_black,1);

	//draw_sprite_tiled_ext(bg_Menu2,0,ww/2-global.ogResWidth/2,0,1,1,c_white,alpha);
	draw_sprite_ext(bg_Zebes,0,ww/2,hh/2,1,1,0,c_white,1);

	var space = 16;

	draw_set_font(fnt_GUI);
	draw_set_color(c_white);
	draw_set_alpha(alpha);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	//var oX = scr_round((ww/2) - 96),
	var oX = scr_round((ww/2) - 128),
		oY = scr_round((hh/2) - 64);
	if(screen == 1)
	{
		oY += space;
	}
	if(screen == 2 || screen == 3)
	{
		var dest = space*optionPos;
		if(optionPos > 7+(screen == 2) && global.aimStyle > 0)
		{
			dest -= space;
		}
		var scrollYDest = clamp(-dest,-(array_length(controlKey)-6)*space,-5*space);
		if(screen == 3)
		{
			scrollYDest = clamp(-dest,-(array_length(controlButton)-6)*space,-5*space);
		}
		var rate = max(abs(scrollYDest - scrollY)*0.25, 1);
		if(scrollY > scrollYDest)
		{
			scrollY = max(scrollY - rate,scrollYDest);
		}
		else
		{
			scrollY = min(scrollY + rate,scrollYDest);
		}
		oY = scr_round((hh/2) + scrollY);
	}
	else
	{
		scrollY = -5*space;
	}

	var str = header[screen],
		sh = string_height(str),
		col = make_color_rgb(72,168,56);

	gpu_set_blendmode(bm_add);
	draw_rectangle_colour(oX - 2,oY - space - 1,oX + 256/*192*/,oY - space + sh,col,c_black,c_black,col,false);
	gpu_set_blendmode(bm_normal);
	draw_set_color(c_black);
	draw_text(oX + 1,oY - space + 1,str);
	draw_set_color(c_white);
	draw_text(oX,oY - space,str);

	var tcol = c_black,
		talph = 0.5*alpha,
		tcol2 = c_white,
		talph2 = 0.15*alpha;

	var tipStrg = "";

	cursorFrameCounter++;
	if(cursorFrameCounter > 5)
	{
		cursorFrame++;
		cursorFrameCounter = 0;
	}
	if(cursorFrame >= 4)
	{
		cursorFrame = 0;
	}

	if(screen == 0)
	{
		for(var i = 0; i < array_length(option); i++)
		{
			var oYY = oY+(i*space);
			var bC = tcol,
				bA = talph,
				indent = 0;
			if(optionPos == i)
			{
				bC = tcol2;
				bA = talph2;
				indent = 4;
			
				draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oYY+string_height(option[i])/2,1,1,0,c_white,alpha);
			}
			var bW = string_width(option[i])+1;
			if(i < 4)
			{
				//bW = 185 - string_width(currentOptionName[i,currentOption[i]]) - indent;
				bW = 249 - string_width(currentOptionName[i,currentOption[i]]) - indent;
			}
			var col3 = c_white;
			//if(i == 6 && global.gpSlot <= -1)
			if(i == 5 || i == 6)
			{
				col3 = c_gray;
			}
			scr_DrawOptionText(oX+indent,oYY,option[i],col3,alpha,bW,bC,bA);
		}
	
		for(var i = 0; i < array_length(currentOption); i++)
		{
			var cOpt = currentOptionName[i,currentOption[i]];
		
			var bC = tcol,
				bA = talph;
			if(optionPos == i)
			{
				bC = tcol2;
				bA = talph2;
			}
			scr_DrawOptionText(oX+256/*192*/-string_width(cOpt),oY+(i*space),cOpt,c_white,alpha,string_width(cOpt),bC,bA);
		}
	
		tipStrg = optionTip[optionPos,0];
		if(optionPos < 2)
		{
			tipStrg = optionTip[optionPos,currentOption[optionPos]];
		}
	}

	if(screen == 1)
	{
		for(var i = 0; i < array_length(advOption); i++)
		{
			var oYY = oY+(i*space);
			var bC = tcol,
				bA = talph,
				indent = 0;
			if(optionPos == i)
			{
				bC = tcol2;
				bA = talph2;
				indent = 4;
			
				draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oYY+string_height(advOption[i])/2,1,1,0,c_white,alpha);
			}
			var bW = string_width(advOption[i])+1;
			if(i < 3)
			{
				//bW = 137;
				//bW = 185 - string_width(advCurrentOptionName[i,advCurrentOption[i]]) - indent;
				bW = 249 - string_width(advCurrentOptionName[i,advCurrentOption[i]]) - indent;
			}
			scr_DrawOptionText(oX+indent,oYY,advOption[i],c_white,alpha,bW,bC,bA);
		}
	
		for(var i = 0; i < array_length(advCurrentOption); i++)
		{
			var cOpt = advCurrentOptionName[i,advCurrentOption[i]];
		
			var bC = tcol,
				bA = talph;
			if(optionPos == i)
			{
				bC = tcol2;
				bA = talph2;
			}
			scr_DrawOptionText(oX+256/*192*/-string_width(cOpt),oY+(i*space),cOpt,c_white,alpha,string_width(cOpt),bC,bA);
		}
	
		tipStrg = advOptionTip[optionPos,0];
		if(optionPos < 4)
		{
			tipStrg = advOptionTip[optionPos,advCurrentOption[optionPos]];
		}
	}

	/*if(screen == 2)
	{
		var yOff = 0;
		for(var i = 0; i < array_length(controlKey); i++)
		{
			if(i != 8 || global.aimStyle == 0)
			{
				var oYY = oY+(i*space)+yOff;
				var bC = tcol,
					bA = talph,
					indent = 0;
				if(optionPos == i)
				{
					bC = tcol2;
					bA = talph2;
					indent = 4;
				
					draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oYY+string_height(controlKey[i])/2,1,1,0,c_white,alpha);
				}
				var bW = string_width(controlKey[i])+1;
				if(i < array_length(currentControlKey))
				{
					var cKeyString = scr_CorrectKeyboardString(currentControlKey[i]);
					if(selectedKey == i)
					{
						cKeyString = textInputKey;
					}
					//bW = 185 - string_width(cKeyString) - indent;
					bW = 249 - string_width(cKeyString) - indent;
				}
				scr_DrawOptionText(oX+indent,oYY,controlKey[i],c_white,alpha,bW,bC,bA);
			}
			else
			{
				yOff -= space;
			}
		}
		yOff = 0;
		for(var i = 0; i < array_length(currentControlKey); i++)
		{
			if(i != 8 || global.aimStyle == 0)
			{
				var cKeyString = scr_CorrectKeyboardString(currentControlKey[i]);
				var bC = tcol,
					bA = talph;
				if(optionPos == i)
				{
					bC = tcol2;
					bA = talph2;
				}
				if(selectedKey == i)
				{
					cKeyString = textInputKey;
					bC = make_color_rgb(40,80,0);
					bA = 0.5*alpha;
				}
			
				var oYY = oY+(i*space)+yOff;
			
				scr_DrawOptionText(oX+256/*192//-string_width(cKeyString),oYY,cKeyString,c_white,alpha,string_width(cKeyString),bC,bA);
			}
			else
			{
				yOff -= space;
			}
		}
	}

	if(screen == 3)
	{
		var yOff = 0;
		for(var i = 0; i < array_length(controlButton); i++)
		{
			if(i != 7 || global.aimStyle == 0)
			{
				var oYY = oY+(i*space)+yOff;
				var bC = tcol,
					bA = talph,
					indent = 0;
				if(optionPos == i)
				{
					bC = tcol2;
					bA = talph2;
					indent = 4;
				
					draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oYY+string_height(controlButton[i])/2,1,1,0,c_white,alpha);
				}
				var bW = string_width(controlButton[i])+1;
				if(i < array_length(currentControlButton))
				{
					var cButtonString = scr_CorrectGamepadString(currentControlButton[i]);
					if(i == 0)
					{
						cButtonString = cButtonToggleName[global.gp_usePad];
					}
					if(i == 1)
					{
						cButtonString = cButtonToggleName[global.gp_useStick];
					}
					if(selectedKey >= 0 && selectedKey == i-3)
					{
						cButtonString = textInputButton;
					}
					//bW = 185 - string_width(cButtonString) - indent;
					bW = 249 - string_width(cButtonString) - indent;
				}
				if(i == 2)
				{
					//bW = 137;
					bW = 197;
				}
				scr_DrawOptionText(oX+indent,oYY,controlButton[i],c_white,alpha,bW,bC,bA);
			}
			else
			{
				yOff -= space;
			}
		}
		yOff = 0;
		for(var i = 0; i < array_length(currentControlButton); i++)
		{
			if(i != 7 || global.aimStyle == 0)
			{
				var bC = tcol,
					bA = talph;
				if(optionPos == i)
				{
					bC = tcol2;
					bA = talph2;
				}
			
				if(i == 2)
				{
					//var bX = oX+144,
					var bX = oX+208,
						bY = oY+(i*space),
						bW = 48;
					draw_set_color(bC);
					draw_set_alpha(bA);
					draw_rectangle(bX-2,bY-1,bX+bW,bY+sh,false);
					draw_set_color(make_color_rgb(26,108,0));
					draw_set_alpha(alpha);
					if(currentControlButton[i] > 0)
					{
						draw_rectangle(bX-1,bY,bX+(bW*currentControlButton[i])-1,bY+sh-1,false);
					}
					draw_set_color(c_white);
					draw_set_halign(fa_middle);
					scr_DrawOptionText(bX+floor(bW/2),bY,string(floor(currentControlButton[i]*100))+"%",c_white,alpha,0,c_black,0);
					draw_set_halign(fa_left);
				}
				else
				{
					var cButtonString = scr_CorrectGamepadString(currentControlButton[i]);
					if(i == 0)
					{
						cButtonString = cButtonToggleName[global.gp_usePad];
					}
					if(i == 1)
					{
						cButtonString = cButtonToggleName[global.gp_useStick];
					}
					if(selectedKey >= 0 && selectedKey == i-3)
					{
						cButtonString = textInputButton;
						bC = make_color_rgb(40,80,0);
						bA = 0.5*alpha;
					}
			
					var oYY = oY+(i*space)+yOff;
			
					scr_DrawOptionText(oX+256/*192//-string_width(cButtonString),oYY,cButtonString,c_white,alpha,string_width(cButtonString),bC,bA);
				}
			}
			else
			{
				yOff -= space;
			}
		}
	}*/

	if(tipStrg != "")
	{
		draw_set_font(fnt_GUI_Small);
		draw_set_halign(fa_middle);
		draw_set_valign(fa_bottom);
		var height = string_height_ext(tipStrg,9,ww);
	
		draw_set_alpha(alpha*0.75);
		draw_set_color(c_black);
		draw_rectangle(-32,hh-height,ww+31,hh,false);
		draw_set_alpha(alpha);
		draw_set_color(c_white);
	
		var col2 = make_color_rgb(26,108,0);
		gpu_set_blendmode(bm_add);
		draw_rectangle_color(-32,hh-height,(ww/2)-1,hh,c_black,col2,col2,c_black,false);
		draw_rectangle_color((ww/2),hh-height,ww+31,hh,col2,c_black,c_black,col2,false);
		gpu_set_blendmode(bm_normal);
	
		draw_set_color(c_black);
		draw_text_ext((ww/2)+1,hh,tipStrg,9,ww);
		draw_set_color(c_white);
		draw_text_ext((ww/2),hh-1,tipStrg,9,ww);
	
		draw_set_font(fnt_GUI);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	draw_surface_ext(application_surface,0,0,1,1,0,c_white,1-alpha);
	
	surface_reset_target();
	
	gpu_set_blendenable(false);
	draw_surface_ext(surf,scr_round(xx),scr_round(yy),1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
	surf = surface_create(global.resWidth,global.resHeight);
}