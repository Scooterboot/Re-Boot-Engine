function BentoUI_Element(_width, _height, _rawText = [], _creatorUI, _parent = other) : BentoConstrAncestor(_parent) constructor
{
	BentoLayoutSetSize(_width, _height);
	BentoLayoutSetMinSize(_width, _height);
	BentoLayoutSetMaxSize(_width, _height);
	
	creatorUI = _creatorUI;
	
	rawText = [];
	if(is_string(_rawText))
	{
		rawText = [_rawText];
	}
	else if(is_array(_rawText))
	{
		rawText = _rawText;
	}
	
	text = [""];
	updateText = true;
	static _GetText = function()
	{
		if(updateText || obj_UI_Controller.updateText)
		{
			for(var i = 0; i < array_length(rawText); i++)
			{
				text[i] = UI_InsertIconsIntoString(rawText[i]);
			}
			updateText = false;
		}
		return text;
	}
	getText = function()
	{
		return _GetText()[0];
	}
	
	enum UI_TextScribType
	{
		None,
		ScribJr,
		ScribDeluxe
	}
	textScribbleType = UI_TextScribType.None;
	
	textFont = fnt_GUI;
	textColor = c_white;
	textAlignX = fa_center;
	textAlignY = fa_middle;
	textOffsetX = 0;
	textOffsetY = 1;
	
	drawText = function(_color, _alignOffX = 4, _alignOffY = 2)
	{
		var _alph = image_alpha,
			_text = getText();
		
		if(is_string(_text) && _text != "")
		{
			var _aOffX = bentoWidth/2;
			if(textAlignX == fa_left) { _aOffX = _alignOffX; }
			if(textAlignX == fa_right) { _aOffX = -_alignOffX; }
			var _aOffY = bentoHeight/2;
			if(textAlignY == fa_top) { _aOffY = _alignOffY; }
			if(textAlignY == fa_bottom) { _aOffY = -_alignOffY; }
			
			var _x = floor(bentoLeft + _aOffX + textOffsetX),
				_y = floor(bentoTop + _aOffY + textOffsetY);
			
			if(textScribbleType == UI_TextScribType.None)
			{
				draw_set_font(textFont);
				draw_set_align(textAlignX, textAlignY);
				draw_set_alpha(_alph);
				draw_text_shadow(_x, _y, _text,,,_color);
				draw_set_alpha(1);
				draw_set_colour(c_white);
			}
			else if(textScribbleType == UI_TextScribType.ScribJr)
			{
				var _scribJr = ScribbleJrExt(_text, textAlignX, textAlignY, textFont);
			
				draw_ScribbleJr_shadow(_scribJr, _x, _y, _color, _alph, , _alph);
			}
			else if(textScribbleType == UI_TextScribType.ScribDeluxe)
			{
				var _scrib = scribble(_text)
					.starting_format(font_get_name(textFont), _color)
					.align(textAlignX,textAlignY);
			
				draw_scribble_shadow(_scrib, _x, _y, _color, _alph, , _alph);
			}
		}
	}
}