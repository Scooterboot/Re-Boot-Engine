/// @description Draw Message

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight;

switch (messageType)
{
	case Message.Item:
	{
		if(messageAlpha > 0)
		{
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			
			var str = header;
			var str2 = InsertIconsIntoString(description);
			if(descScrib.text != str2)
			{
				descScrib.overwrite(str2);
			}
			
			//draw_set_font(GUIFontSmall);
			var str2W = descScrib.get_width(),//string_width(str2),
				boxW = sprite_get_width(sprt_MessageBox),
				boxW2 = 190,
				boxScaleX = 1;
			if(str2W > boxW2)
			{
				boxScaleX = (boxW + (str2W-boxW2)) / boxW;
			}
			
			draw_sprite_ext(sprt_MessageBox,0,xx+(ww/2),yy+(hh/2),boxScaleX,lerp(0.42,1,messageAlpha),0,c_white,messageAlpha);
			
			draw_set_font(fnt_Menu2);
			scr_DrawOptionText(xx+(ww/2),yy+(hh/2)-string_height(str)-4,str,c_yellow,messageAlpha,0,c_black,0);
			
			//draw_set_font(GUIFontSmall);
			//scr_DrawOptionText(xx+(ww/2),yy+(hh/2),str2,c_white,messageAlpha,0,c_black,0);
			descScrib.blend(c_black,messageAlpha);
			descScrib.draw(xx+(ww/2)+1,yy+(hh/2)+1);
			descScrib.blend(c_white,messageAlpha);
			descScrib.draw(xx+(ww/2),yy+(hh/2));
		}
		break;
	}
	case Message.Expansion:
	{
		if(messageAlpha > 0)
		{
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			
			var str = header,
				str2 = description;
			
			var orderYDiff = 20*order;
			
			draw_set_font(fnt_GUI);
			scr_DrawOptionText(xx+(ww/2),yy+(hh/3)+orderYDiff-string_height(str),str,c_white,messageAlpha,0,c_black,0);
			
			draw_set_font(fnt_GUI_Small2);
			scr_DrawOptionText(xx+(ww/2),yy+(hh/3)+orderYDiff,str2,c_white,messageAlpha,0,c_black,0);
		}
		break;
	}
	case Message.Simple:
	{
		if(messageAlpha > 0)
		{
			draw_set_font(fnt_GUI);
			draw_set_halign(fa_center);
			draw_set_valign(fa_center);
			var str = header;
			var orderYDiff = 16*order;
			scr_DrawOptionText(xx+(ww/2),yy+(hh/4)+orderYDiff,str,c_white,messageAlpha,0,c_black,0);
		}
	}
}