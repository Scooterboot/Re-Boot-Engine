function BentoUI_ConfirmPanel(_width, _height, _rawText = [], _creatorUI, _parent = other) : BentoUI_Element(_width, _height, _rawText, _creatorUI, _parent) constructor
{
	eventDraw = function()
	{
		var _x = bentoLeft,
			_y = bentoTop,
			_alpha = image_alpha;
		
		BentoDrawClear(, 0.5 * _alpha);
		BentoDrawSprite(sprt_UI_MessageBox, 0);
		
		textFont = fnt_Menu;
		textAlignY = fa_top;
		textScribbleType = UI_TextScribType.ScribDeluxe;
		drawText(textColor);
	}
}