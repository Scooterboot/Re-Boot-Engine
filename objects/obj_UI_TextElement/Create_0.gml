event_inherited();

sprt = sprt_UI_OptPanel;
sprtAlpha = 0.65;

textScrib = scribble(text);
textScrib.starting_format("fnt_GUI",c_white);
textScrib.align(fa_center,fa_middle);

function PreDraw(_x, _y)
{
	var _sprt = sprt,
		_ww = max(width, sprite_get_width(_sprt)),
		_hh = max(height, sprite_get_height(_sprt)),
		_xx = _x+width/2-_ww/2,
		_yy = _y+height/2-_hh/2,
		_alph = self.GetAlpha() * sprtAlpha;
	draw_sprite_stretched_ext(_sprt,1, _xx,_yy, _ww,_hh, c_white,_alph);
	
	var _text = text,
		_str = obj_UI_Icons.InsertIconsIntoString(_text);
	if(textScrib.get_text() != _str)
	{
		textScrib.overwrite(_str);
	}
	
	var xx = _x+width/2, yy = _y+height/2+1;
	textScrib.blend(c_black,1);
	textScrib.draw(xx+1,yy+1);
	textScrib.blend(c_white,1);
	textScrib.draw(xx,yy);
}