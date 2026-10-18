function BentoUI_ScrollList_Page(_width, _height, _gutter, _creatorUI, _parent = other) : BentoUI_Element(_width, _height, [], _creatorUI, _parent) constructor
{
	BentoLayoutList(BENTO_AXIS_Y, 0, 0);
	BentoLayoutSetGutter(0, _gutter);
	BentoLayoutSetPadding(0);
	BentoClipSetEnabled(true);
	BentoClipSetPadding(0,0,0,0);
	BentoScrollSetEnabled(false, true);
	
	BentoScrollbarSetVert(false, 7, -8, 1, -8, 1, false);
	BentoSetDrawAfter(true);
	
	eventDrawAfter = function()
	{
		with(BentoScrollbarGetVertData())
		{
			if (exists)
			{
				var _ind = 1;
				if(hoverHandle)
				{
					_ind = 2;
				}
				
				draw_sprite_stretched_ext(sprt_UI_Scrollbar, 0, barLeft, barTop, barRight - barLeft, barBottom - barTop, c_white, 1);
				draw_sprite_stretched_ext(sprt_UI_Scrollbar, _ind, handleLeft, handleTop, handleRight - handleLeft, handleBottom - handleTop, c_white, 1);
			}
		}
	}
}