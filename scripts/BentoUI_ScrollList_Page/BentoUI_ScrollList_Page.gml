function BentoUI_ScrollList_Page(_width, _height, _gutter, _parent = other) : BentoUI_Element(_width, _height, [], _parent) constructor
{
	BentoLayoutList(BENTO_AXIS_Y, 0, 0);
	BentoLayoutSetGutter(0, _gutter);
	BentoClipSetEnabled(true);
	BentoScrollSetEnabled(false, true);
	
	BentoScrollbarSetVert(false, 7, 1, 1, 1, 1, false);
	BentoSetDrawAfter(true);
	
	eventDrawAfter = function()
	{
		with(BentoScrollbarGetVertData())
		{
			if (exists)
			{
				draw_sprite_stretched_ext(sprt_UI_Scrollbar, 0, barLeft, barTop, barRight - barLeft, barBottom - barTop, c_white, 1);
				draw_sprite_stretched_ext(sprt_UI_Scrollbar, 1, handleLeft, handleTop, handleRight - handleLeft, handleBottom - handleTop, c_white, 1);
			}
		}
	}
}