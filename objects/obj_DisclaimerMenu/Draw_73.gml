/// @description 
var xx = 0,//camera_get_view_x(view_camera[0]),
	yy = 0,//camera_get_view_y(view_camera[0]),
	ww = room_width,//global.resWidth,
	hh = room_height,//global.resHeight,
	alpha = screenFade;

if(room == rm_Disclaimer)
{
	draw_set_font(fnt_GUI_Small);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	
	var oX = ww/2,
		oY = 16;
	
	for(var i = 0; i < array_length(disclaimer); i++)
	{
		if(i > 0)
		{
			oY += string_height(disclaimer[i-1]) + 8;
		}
		scr_DrawOptionText(oX,oY,disclaimer[i],c_white,revealText[i],0,c_black,0);
	}
	
	if(revealText[5] > 0)
	{
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
				
		draw_set_font(fnt_Menu2);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);

		for(var i = 0; i < array_length(option); i++)
		{
			oX = scr_round(ww/2 - string_width(option[i])/2);
			oY = scr_round(hh - space*4) + i*space;
	
			var col = c_black,
				alph = 0.5,
				indent = 0;
			if(optionPos == i)
			{
				col = c_white;
				alph = 0.15;
				indent = 0;//4;
		
				draw_sprite_ext(sprt_UI_SelectCursor,cursorFrame,oX+indent-4,oY+string_height(option[i])/2,1,1,0,c_white,revealText[5]);
			}
			scr_DrawOptionText(oX+indent,oY,option[i],c_white,revealText[5],string_width(option[i])+1,col,revealText[5]*alph);
		}
		
		buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1];
		var str = InsertIconsIntoString(buttonTipString);
		if(buttonTipScrib.get_text() != str)
		{
			buttonTipScrib.overwrite(str);
		}
	
		var height = buttonTipScrib.get_height();

		draw_set_alpha(revealText[5]*0.75);
		draw_set_color(c_black);
		draw_rectangle(xx-32,yy+hh-height,xx+ww+31,yy+hh,false);
		draw_set_alpha(revealText[5]);
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
	}
}

draw_set_color(c_black);
draw_set_alpha(alpha);
draw_rectangle(xx-1,yy-1,xx+ww+1,yy+hh+1,false);
draw_set_alpha(1);