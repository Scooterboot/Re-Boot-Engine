event_inherited();

sprt = sprt_UI_OptPanel;
sprtAlpha = 0.65;

function PreDraw(_x, _y)
{
	var _sprt = sprt,
		_ww = max(width, sprite_get_width(_sprt)),
		_hh = max(height, sprite_get_height(_sprt)),
		_xx = _x+width/2-_ww/2,
		_yy = _y+height/2-_hh/2,
		_alph = self.GetAlpha(),
		_alph2 = _alph * sprtAlpha;
	draw_sprite_stretched_ext(_sprt,1, _xx,_yy, _ww,_hh, c_white,_alph2);
	
	var _text = self.GetText();
	var _scrib = scribble(_text)
		.starting_format(font_get_name(textFont),textColor)
		.align(textAlignX,textAlignY);
	
	var _alignOffX = width/2;
	if(textAlignX == fa_left) { _alignOffX = 4; }
	if(textAlignX == fa_right) { _alignOffX = -4; }
	var _alignOffY = height/2;
	if(textAlignY == fa_top) { _alignOffY = 2; }
	if(textAlignY == fa_bottom) { _alignOffY = -2; }
	
	draw_scribble_shadow(_scrib, _x+_alignOffX, _y+_alignOffY+1,textColor,_alph,,_alph);
}
