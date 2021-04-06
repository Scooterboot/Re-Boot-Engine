/// @description Draw Main Menu
var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight,
	alpha = screenFade;

if(currentScreen == MainScreen.TitleIntro)
{
	//intro stuffs
}
if(currentScreen == MainScreen.Title)
{
	draw_sprite_ext(sprt_Title,0,xx+(ww/2),yy+39,1,1,0,c_white,titleFade);
	
	if(pressStartAnim < 40)
	{
		var stX = xx+(ww/2),
			stY = yy+hh-40;
	
		draw_set_font(GUIFont);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		var col3 = c_yellow;
		if(pressStartAnim%2 != 0)
		{
			col3 = c_black;
		}
		scr_DrawOptionText(stX,stY,startString,col3,titleFade,0,c_black,0);
	}
}
if(currentScreen == MainScreen.FileSelect)
{
	draw_sprite_tiled_ext(bg_Menu2,0,scr_round(xx)+ww/2-global.ogResWidth/2,scr_round(yy),1,1,c_white,1);
	
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
				
	var space = 14;
				
	draw_set_font(GUIFont);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var oX = scr_round(ww/2 - 96),
		oY = scr_round(hh/2);
				
	for(var o = 3; o < array_length(option); o++)
	{
		var oY2 = oY + (o*space);
					
		var col = c_black,
			alph = 0.5,
			indent = 0;
		if(optionPos == o)
		{
			col = c_white;
			alph = 0.15;
			indent = 4;
			
			draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX+indent-4,oY2+string_height(option[o])/2,1,1,0,c_white,1);
		}
		scr_DrawOptionText(oX+indent,oY2,option[o],c_white,1,string_width(option[o])+1,col,alph);
	}
	
	//oX = 18;
	oX = ww/2 - 110;
	var oX2 = 18;
	oY = 48;
	space = 32;
	
	for(var i = 0; i < 3; i++)
	{
		draw_set_font(GUIFont);
		
		var oY2 = oY + (i*space);
					
		var col = c_black,
			alph = 0.5,
			frame = 0;
		if(optionPos == i)
		{
			col = c_white;
			alph = 0.15;
			frame = fileIconFrame;
			
			if(selectedFile != i)
			{
				draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX-4,oY2+string_height(option[i])/2,1,1,0,c_white,1);
			}
		}
		
		draw_set_alpha(alph);
		draw_set_color(col);
		draw_roundrect(oX-3,oY2-10,ww-oX+1,oY2+string_height(option[i])+8,false);
		
		draw_sprite_ext(sprt_FileIcon,frame,oX+string_width(option[i])+12,oY2+(string_height(option[i])/2),1,1,0,c_white,1);
		
		draw_set_font(MenuFont);
		scr_DrawOptionText(oX,oY2,option[i],c_white,1,0,c_black,0);
		
		draw_set_font(GUIFontSmall);
		scr_DrawOptionText(ww-oX-string_width(timeText)-8,oY2-string_height(timeText)+2,timeText,c_white,1,0,c_black,0);
		if(fileTime[i] >= 0)
		{
			var minute = scr_floor(fileTime[i] / 60);
			var hour = scr_floor(minute / 60);
			var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0);
			tStr = string_replace_all(tStr," ","0");
			
			draw_set_font(MenuFont);
			scr_DrawOptionText(scr_round(ww-oX-(string_width(tStr)/2)-18),scr_round(oY2+(string_height(tStr)/2)),tStr,c_white,1,0,c_black,0);
		}
		
		if(selectedFile != i)
		{
			if(fileEnergy[i] < 0)
			{
				draw_set_font(GUIFont);
				scr_DrawOptionText(oX2+(ww/2)-(string_width(noDataText)/2),oY2,noDataText,c_white,1,0,c_black,0);
			}
			else
			{
				draw_set_font(GUIFontSmall);
				scr_DrawOptionText(oX2+(ww/2)-string_width(energyText)-2,oY2-string_height(timeText)+4,energyText,c_white,1,0,c_black,0);
				
				draw_set_font(MenuFont);
				var str = string(fileEnergy[i]);
				str = string_char_at(str,string_length(str)-1)+string_char_at(str,string_length(str));
				scr_DrawOptionText(oX2+(ww/2)-(string_width(str)/2)-20,oY2+2,str,c_white,1,0,c_black,0);
				
				
				var energyTanks = floor(fileEnergyMax[i] / 100),
					statEnergyTanks = floor(fileEnergy[i] / 100);
				var tx = oX2+(ww/2),
					ty = oY2-4;
				if(energyTanks > 0)
				{
					for(var j = 0; j < energyTanks; j++)
					{
						var eX = tx + (7*j),
						eY = ty;
						if(energyTanks > 7)
						{
							eY = ty+7;
						}
						if(j >= 7)
						{
							eX = tx + (7*(j-7));
							eY = ty;
						}
						draw_sprite_ext(sprt_HETank,(statEnergyTanks > j),floor(eX),floor(eY),1,1,0,c_white,1);
					}
				}
			}
		}
		else if(selectedFile == i)
		{
			draw_set_font(GUIFont);
			var exists = file_exists(scr_GetFileName(i));
			for(var j = 0; j < 2; j++)
			{
				if(j <= 0 || exists)
				{
					var sx = scr_ceil(oX2+(ww/2)-(string_width(subOption[j])/2)+10),
						sy = oY2;
					if(exists)
					{
						sy = oY2-5 + 10*j;
					}
					
					var col2 = make_color_rgb(26,108,0),
						alph2 = 0;
					if(optionSubPos == j)
					{
						alph2 = 0.5;
			
						draw_sprite_ext(sprt_SelectCursor,cursorFrame,sx-4,sy+string_height(subOption[j])/2,1,1,0,c_white,1);
					}
					
					scr_DrawOptionText(sx,sy,subOption[j],c_white,1,scr_ceil(string_width(subOption[j])+2),col2,alph2);
				}
			}
		}
	}
	
	var bTip = buttonTip[2];
	if(selectedFile != -1)
	{
		bTip = buttonTip[3];
	}

	var moveKeys = scr_CorrectKeyboardString(global.key[0])+","+scr_CorrectKeyboardString(global.key[2])+","+scr_CorrectKeyboardString(global.key[1])+","+scr_CorrectKeyboardString(global.key[3]);
	if(global.key[0] == vk_up && global.key[1] == vk_down && global.key[2] == vk_left && global.key[3] == vk_right)
	{
		moveKeys = "Arrow keys";
	}
	var acceptKey = scr_CorrectKeyboardString(global.key_m[1]),
		cancelKey = scr_CorrectKeyboardString(global.key_m[2]);

	var tipStrg = moveKeys+" - "+buttonTip[0]+"   "+acceptKey+" - "+buttonTip[1]+"   "+cancelKey+" - "+bTip;

	draw_set_font(GUIFontSmall);
	draw_set_valign(fa_bottom);
	var height = string_height_ext(tipStrg,9,ww);

	draw_set_alpha(0.75);
	draw_set_color(c_black);
	draw_rectangle(xx-32,yy+hh-height,xx+ww+31,yy+hh,false);
	draw_set_alpha(1);
	draw_set_color(c_white);

	var col2 = make_color_rgb(26,108,0);
	gpu_set_blendmode(bm_add);
	draw_rectangle_color(xx-32,yy+hh-height,xx+(ww/2)-1,yy+hh,c_black,col2,col2,c_black,false);
	draw_rectangle_color(xx+(ww/2),yy+hh-height,xx+ww+31,yy+hh,col2,c_black,c_black,col2,false);
	gpu_set_blendmode(bm_normal);

	if(obj_Control.usingGamePad)
	{
		var tipx = xx+(ww/2),
			tipy = yy+hh,
			mText = " - "+buttonTip[0]+"   ",
			aText = " - "+buttonTip[1]+"   ",
			cText = " - "+bTip,
			dSprt = sprt_DPad,
			bSprt = sprt_xbButton;
		
		var totalWidth = sprite_get_width(dSprt)+string_width(mText)+sprite_get_width(bSprt)+string_width(aText)+sprite_get_width(bSprt)+string_width(cText);
		tipx = tipx-totalWidth/2;
		
		draw_set_halign(fa_left);
		
		draw_sprite_ext(dSprt,0,scr_round(tipx+sprite_get_width(dSprt)/2),scr_round(tipy-sprite_get_height(dSprt)+1),1,1,0,c_white,1);
		tipx += sprite_get_width(dSprt);
		scr_DrawOptionText(scr_round(tipx),scr_round(tipy),mText,c_white,1,0,c_black,0);
		tipx += string_width(mText);
		
		draw_sprite_ext(bSprt,scr_GetButtonSprtIndexXB(global.gp_m[1]),scr_round(tipx+sprite_get_width(bSprt)/2),scr_round(tipy-sprite_get_height(bSprt)+1),1,1,0,c_white,1);
		tipx += sprite_get_width(bSprt);
		scr_DrawOptionText(scr_round(tipx),scr_round(tipy),aText,c_white,1,0,c_black,0);
		tipx += string_width(aText);
		
		draw_sprite_ext(bSprt,scr_GetButtonSprtIndexXB(global.gp_m[2]),scr_round(tipx+sprite_get_width(bSprt)/2),scr_round(tipy-sprite_get_height(bSprt)+1),1,1,0,c_white,1);
		tipx += sprite_get_width(bSprt);
		scr_DrawOptionText(scr_round(tipx),scr_round(tipy),cText,c_white,1,0,c_black,0);
		
	}
	else
	{
		draw_set_halign(fa_middle);
		draw_set_color(c_black);
		draw_text_ext(scr_round(xx+(ww/2)+1),scr_round(yy-1+hh+1),tipStrg,9,ww);
		draw_set_color(c_white);
		draw_text_ext(scr_round(xx+(ww/2)),scr_round(yy-1+hh),tipStrg,9,ww);
	}

	draw_set_font(GUIFont);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	draw_set_alpha(1);
	draw_set_color(c_black);
}

draw_set_color(c_black);
draw_set_alpha(alpha);
draw_rectangle(xx-1,yy-1,xx+ww+1,yy+hh+1,false);
draw_set_alpha(1);