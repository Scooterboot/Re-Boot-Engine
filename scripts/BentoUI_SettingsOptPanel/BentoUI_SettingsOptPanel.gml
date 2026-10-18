function BentoUI_SettingsOptPanel(_width, _height, _rawText = [], _creatorUI, _parent = other) : BentoUI_Element(_width, _height, _rawText, _creatorUI, _parent) constructor
{
	eventDraw = function()
	{
		var _imgInd = 1;
		if(BentoCursorGetHover())
		{
			_imgInd = 0;
		}
		else
		{
			var _childArr = BentoGetChildArray();
			for(var i = array_length(_childArr)-1; i >= 0; i--)
			{
				if(BentoCursorGetHover(_childArr[i]))
				{
					_imgInd = 0;
					break;
				}
			}
		}
		
		BentoDrawSprite(sprt_UI_OptPanel, _imgInd);
		
		textAlignX = fa_left;
		drawText(textColor);
	}
}