/// @description Draw Main Menu
var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight,
	alpha = min(screenFade,1);

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
	
		draw_set_font(fnt_GUI);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		//var col3 = c_yellow;
		//if(pressStartAnim%2 != 0)
		if(pressStartAnim%6 >= 3)
		{
			//col3 = c_white;
			//draw_set_color(c_white);
			//draw_set_alpha(titleFade*0.5);
			draw_set_color(c_ltgray);
			draw_set_alpha(titleFade);
			for(var i = 0; i < 8; i++)
			{
				draw_text(scr_round(stX+lengthdir_x(1.1,45*i)),scr_round(stY+lengthdir_y(1.1,45*i)),startString);
			}
			draw_set_color(c_yellow);
			draw_set_alpha(titleFade*0.75);
			draw_text(scr_round(stX),scr_round(stY),startString);
		}
		else
		{
			scr_DrawOptionText(stX,stY,startString,c_yellow,titleFade,0,c_black,0);
		}
	}
}
if(currentScreen == MainScreen.FileSelect || currentScreen == MainScreen.FileCopy)
{
	//draw_sprite_tiled_ext(bg_Menu2,0,scr_round(xx)+ww/2-global.ogResWidth/2,scr_round(yy),1,1,c_white,1);
	draw_sprite_ext(bg_Zebes,0,scr_round(xx+ww/2),scr_round(yy+hh/2),1,1,0,c_white,1);
	
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
				
	draw_set_font(fnt_GUI);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var oX = scr_round(ww/2 - 96),
		oY = scr_round(hh/2);
	
	var fOption = option;
	if(currentScreen == MainScreen.FileCopy)
	{
		fOption = copyOption;
	}
	
	if(!confirmQuitDT && !confirmCopy && !confirmDelete)
	{
		for(var o = 3; o < array_length(fOption); o++)
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
			
				draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX+indent-4,oY2+string_height(fOption[o])/2,1,1,0,c_white,1);
			}
			scr_DrawOptionText(oX+indent,oY2,fOption[o],c_white,1,string_width(fOption[o])+1,col,alph);
		}
	}
	else 
	{
		draw_set_font(fnt_GUI);
		
		/*draw_set_color(c_black);
		draw_set_alpha(0.75);
		draw_rectangle(xx-2,yy-2,xx+ww+2,yy+hh+2,false);
		draw_set_alpha(1);*/
		
		//space = 16;
		
		//var oX = scr_round(ww/2),
		//	oY = scr_round(hh/2 - space*2);
		oX = scr_round(ww/2);
		oY = scr_round(hh/2) + (space*2.5);
		
		var text = option[optionPos];
		if(confirmCopy && selectedFile != -1)
		{
			text = confirmCopyText[0] + " " + copyOption[selectedFile] + " " + confirmCopyText[1] + " " + copyOption[copyFile];
		}
		if(confirmDelete && selectedFile != -1)
		{
			text = confirmDeleteText + " " + option[selectedFile];
		}
		scr_DrawOptionText(scr_round(oX-string_width(text)/2),oY,text,c_white,1,string_width(text)+1,c_black,0.5);
		text = confirmText[0];
		scr_DrawOptionText(scr_round(oX-string_width(text)/2),oY+space,text,c_white,1,string_width(text)+1,c_black,0.5);
		
		var oY2 = oY + space*2;
		for(var i = 0; i < 2; i++)
		{
			text = confirmText[1+i];
			
			var oX2 = scr_round((oX + space*1.5 - i*space*3) - string_width(text)/2),
				col = c_black,
				alph = 0.5,
				indent = 0;
			if(confirmPos == i)
			{
				col = c_white;
				alph = 0.15;
				indent = 4;
				
				draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX2-4,oY2+string_height(text)/2,1,1,0,c_white,1);
			}
			scr_DrawOptionText(oX2,oY2,text,c_white,1,string_width(text)+1,col,alph);
		}
	}
	
	//oX = 18;
	oX = ww/2 - 128;//110;
	var oX2 = 18;
	oY = 48;
	space = 40;//32;
	
	for(var i = 0; i < 3; i++)
	{
		draw_set_font(fnt_GUI);
		
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
				draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX-4,oY2+string_height(fOption[i])/2,1,1,0,c_white,1);
			}
		}
		
		if(currentScreen == MainScreen.FileCopy && selectedFile == i)
		{
			col = c_yellow;
			alph = 0.4;
		}
		
		draw_set_alpha(alph);
		draw_set_color(col);
		draw_roundrect(oX-3,oY2-14,ww-oX+1,oY2+string_height(fOption[i])+12,false);
		
		draw_set_font(fnt_Menu);
		draw_sprite_ext(sprt_FileIcon,frame,oX+string_width(fOption[i])+8,oY2+(string_height(fOption[i])/2),1,1,0,c_white,1);
		
		scr_DrawOptionText(oX+2,oY2,fOption[i],c_white,1,0,c_black,0);
		
		if(fileTime[i] >= 0)
		{
			draw_set_font(fnt_GUI_Small2);
			scr_DrawOptionText(ww-oX-string_width(timeText)-12,oY2-string_height(timeText)+4,timeText,c_white,1,0,c_black,0);
			var minute = scr_floor(fileTime[i] / 60);
			var hour = scr_floor(minute / 60);
			while(minute >= 60)
			{
				minute -= 60;
			}
			var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0);
			tStr = string_replace_all(tStr," ","0");
			
			draw_set_font(fnt_Menu2);
			scr_DrawOptionText(scr_round(ww-oX-(string_width(tStr)/2)-22),scr_round(oY2+(string_height(tStr)/2)),tStr,c_white,1,0,c_black,0);
		}
		if(filePercent[i] >= 0)
		{
			var px = ww/2+66;
				
			draw_set_font(fnt_GUI_Small2);
			scr_DrawOptionText(px-string_width(itemsText)/2-2,oY2-string_height(itemsText)+4,itemsText,c_white,1,0,c_black,0);
			var percent = scr_floor(filePercent[i]);
			var pStr = string_format(percent,2,0)+"%";
			pStr = string_replace_all(pStr," ","0");
			
			draw_set_font(fnt_Menu2);
			scr_DrawOptionText(scr_round(px-(string_width(pStr)/2)-2),scr_round(oY2+(string_height(pStr)/2)),pStr,c_white,1,0,c_black,0);
		}
		
		if(selectedFile != i || currentScreen == MainScreen.FileCopy)
		{
			if(fileEnergy[i] < 0)
			{
				draw_set_font(fnt_GUI);
				scr_DrawOptionText(oX2+(ww/2)-(string_width(noDataText)/2),oY2,noDataText,c_white,1,0,c_black,0);
			}
			else
			{
				var tx = ww/2-10,
					ty = oY2-4;
				draw_set_font(fnt_GUI_Small2);
				scr_DrawOptionText(tx-string_width(energyText)-2,oY2-string_height(timeText)+4,energyText,c_white,1,0,c_black,0);
				
				draw_set_font(fnt_Menu);
				var str = string(fileEnergy[i]);
				str = string_char_at(str,string_length(str)-1)+string_char_at(str,string_length(str));
				scr_DrawOptionText(tx-(string_width(str)/2)-16,oY2+2,str,c_white,1,0,c_black,0);
				
				
				var energyTanks = floor(fileEnergyMax[i] / 100),
					statEnergyTanks = floor(fileEnergy[i] / 100);
				if(energyTanks > 0)
				{
					/*for(var j = 0; j < energyTanks; j++)
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
					}*/
					for(var j = 0; j < energyTanks; j++)
					{
						var eX = tx + (7*j)/2,
							eY = ty;
						if(j%2 != 0)
						{
							eX = tx + (7*(j-1))/2;
							eY = ty+7;
						}
						draw_sprite_ext(sprt_HETank,(statEnergyTanks > j),floor(eX),floor(eY),1,1,0,c_white,1);
					}
				}
			}
		}
		else if(selectedFile == i)
		{
			draw_set_font(fnt_GUI);
			var exists = file_exists(scr_GetFileName(i));
			for(var j = 0; j < 3; j++)
			{
				if(j <= 0 || exists)
				{
					var sx = scr_ceil(oX2+(ww/2)-(string_width(subOption[0])/2)-10),
						sy = oY2;
					if(exists)
					{
						sx -= 10;
						sy = oY2-10 + 10*j;
					}
					
					var col2 = make_color_rgb(26,108,0),
						alph2 = 0;
					if(optionSubPos == j)
					{
						alph2 = 0.5;
						sx += 4;
			
						draw_sprite_ext(sprt_SelectCursor,cursorFrame,sx-4,sy+string_height(subOption[j])/2,1,1,0,c_white,1);
					}
					
					scr_DrawOptionText(sx,sy,subOption[j],c_white,1,scr_ceil(string_width(subOption[j])+2),col2,alph2);
				}
			}
		}
	}
	
	var bTip = buttonTip[2];
	if(selectedFile != -1 || confirmQuitDT || confirmCopy || confirmDelete)
	{
		bTip = buttonTip[3];
	}
	buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1]+"   ${menuCancelButton} - "+bTip;
	var str = InsertIconsIntoString(buttonTipString);
	if(buttonTipScrib.get_text() != str)
	{
		buttonTipScrib.overwrite(str);
	}
	
	var height = buttonTipScrib.get_height();

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
	
	var tipx = scr_round(xx+(ww/2)),
		tipy = scr_round(yy+hh-4);
	
	buttonTipScrib.blend(c_black,1);
	buttonTipScrib.draw(tipx+1,tipy+1);
	buttonTipScrib.blend(c_white,1);
	buttonTipScrib.draw(tipx,tipy);

	draw_set_font(fnt_GUI);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	draw_set_alpha(1);
	draw_set_color(c_black);
}

draw_set_color(c_black);
draw_set_alpha(alpha);
draw_rectangle(xx-1,yy-1,xx+ww+1,yy+hh+1,false);
draw_set_alpha(1);