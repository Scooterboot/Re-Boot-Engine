
if(messageAlpha > 0)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	switch (messageType)
	{
		case Message.Item:
		{
			var _headScrib = scribble(header)
				.starting_format(font_get_name(fnt_Menu),c_yellow)
				.align(fa_center,fa_top);
			
			var _descScrib = scribble(description)
				.starting_format(font_get_name(fnt_GUI_Small),c_white)
				.align(fa_center,fa_top);
			
			var str2W = _descScrib.get_width(),
				boxW = sprite_get_width(sprt_UI_MessageBox),
				str2H = _descScrib.get_height(),
				boxH = sprite_get_height(sprt_UI_MessageBox),
				boxH2 = 34;
			
			var fWidth = max(boxW,str2W+56),
				scaleW = fWidth/boxW,
				offX = sprite_get_xoffset(sprt_UI_MessageBox) * scaleW,
				fHeight = lerp(boxH2,max(boxH,str2H+20),messageAlpha),
				fHeight2 = max(boxH,str2H+20)/2,
				scaleH = fHeight/boxH,
				offY = sprite_get_yoffset(sprt_UI_MessageBox) * scaleH;
			
			draw_sprite_stretched_ext(sprt_UI_MessageBox, 0, (ww/2)-offX, (hh/2)-offY, fWidth, fHeight, c_white, messageAlpha);
			
			draw_scribble_shadow(_headScrib, (ww/2), (hh/2)-fHeight2+4,c_yellow,messageAlpha,,messageAlpha);
			draw_scribble_shadow(_descScrib, (ww/2), (hh/2)+fHeight2-4-str2H,,messageAlpha,,messageAlpha);
			
			break;
		}
		case Message.Expansion:
		{
			var _headScrib = scribble(header)
				.starting_format(font_get_name(fnt_GUI),c_white)
				.align(fa_center,fa_top);
			
			var _descScrib = scribble(description)
				.starting_format(font_get_name(fnt_GUI_Small),c_white)
				.align(fa_center,fa_top);
			
			var orderYDiff = 20*order;
			draw_scribble_shadow(_headScrib, (ww/2), (hh/3)+orderYDiff-_headScrib.get_height(),,messageAlpha,,messageAlpha);
			draw_scribble_shadow(_descScrib, (ww/2), (hh/3)+orderYDiff,,messageAlpha,,messageAlpha);
			
			break;
		}
		case Message.Simple:
		{
			var _scrib = scribble(header)
				.starting_format(font_get_name(fnt_GUI),c_white)
				.align(fa_center,fa_middle);
			
			var orderYDiff = 16*order;
			draw_scribble_shadow(_scrib, (ww/2), (hh/4)+orderYDiff,,messageAlpha,,messageAlpha);
			break;
		}
	}
	
	bm_reset();
	surface_reset_target();
}
