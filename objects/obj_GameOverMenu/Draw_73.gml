/// @description Draw Game Over Menu
var xx = max(camera_get_view_x(view_camera[0]),0),
	yy = max(camera_get_view_y(view_camera[0]),0),
	ww = min(room_width,global.resWidth),
	hh = min(room_height,global.resHeight),
	alpha = screenFade;

if(room == rm_GameOver)
{
	//draw_sprite_ext(bg_Space,0,scr_round(xx+ww/2),scr_round(yy+hh/2),1,1,0,c_white,1);
	
	draw_set_font(fnt_Menu);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_DrawOptionText(xx+ww/2,yy+hh/6,gameOverText,c_red,1,string_width(gameOverText)+1,c_black,0);
	
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
	var oX = xx+scr_round(ww/2 - 64),
		oY = yy+scr_round(hh/2 + space);

	if(confirmQuitMM == -1 && confirmQuitDT == -1)
	{
		for(var i = 0; i < array_length(option); i++)
		{
			var oY2 = oY + i*space;
			oX = xx+scr_round(ww/2 - string_width(option[i])/2);
	
			var col = c_black,
				alph = 0.5,
				indent = 0;
			if(optionPos == i)
			{
				col = c_white;
				alph = 0.15;
				indent = 0;//4;
		
				draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oY2+string_height(option[i])/2,1,1,0,c_white,1);
			}
			scr_DrawOptionText(oX+indent,oY2,option[i],c_white,1,string_width(option[i])+1,col,alph);
		}
	}
	else
	{
		oX = xx+scr_round(ww/2);
		oY = yy+scr_round(hh/2);// - space*2);
					
		var text = option[optionPos];
		scr_DrawOptionText(scr_round(oX-string_width(text)/2),oY,text,c_white,1,string_width(text)+1,c_black,0.5);
		text = confirmText[0];
		scr_DrawOptionText(scr_round(oX-string_width(text)/2),oY+space*1.5,text,c_white,1,string_width(text)+1,c_black,0.5);
					
		var oY2 = yy+scr_round(hh/2 + space*3);
		for(var i = 0; i < 2; i++)
		{
			text = confirmText[1+i];
						
			//var oX2 = scr_round(oX - space*1.5 + i*space*3 - string_width(text)/2),
			var oX2 = scr_round((oX + space*1.5 - i*space*3) - string_width(text)/2),
				col = c_black,
				alph = 0.5,
				indent = 0;
			if(confirmPos == i)
			{
				col = c_white;
				alph = 0.15;
				indent = 4;
							
				draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX2-4,oY2+string_height(text)/2,1,1,0,c_white,1);
			}
			scr_DrawOptionText(oX2,oY2,text,c_white,1,string_width(text)+1,col,alph);
		}
	}

	//buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1];
	var _tipStr = buttonTipString[0];
	if(confirmQuitMM != -1 || confirmQuitDT != -1)
	{
		//buttonTipString = buttonTipString + "   ${menuCancelButton} - "+buttonTip[2];
		_tipStr = buttonTipString[1];
	}
	var str = obj_UIHandler.InsertIconsIntoString(_tipStr);
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
	draw_rectangle_color(xx-32,yy+hh-height,xx+(ww/2),yy+hh,c_black,col2,col2,c_black,false);
	draw_rectangle_color(xx+(ww/2),yy+hh-height,xx+ww+32,yy+hh,col2,c_black,c_black,col2,false);
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
}

draw_set_color(c_black);
draw_set_alpha(alpha);
draw_rectangle(xx-1,yy-1,xx+ww+1,yy+hh+1,false);
draw_set_alpha(1);
