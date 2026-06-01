event_inherited();

sprt = sprt_UI_OptPanel;
sprtAlpha = 0.65;

function PreDraw()
{
	var _x = posX,
		_y = posY,
		_sprt = sprt,
		_ww = max(width, sprite_get_width(_sprt)),
		_hh = max(height, sprite_get_height(_sprt)),
		_xx = _x+width/2-_ww/2,
		_yy = _y+height/2-_hh/2,
		_alph = alpha,
		_alph2 = _alph * sprtAlpha;
	draw_sprite_stretched_ext(_sprt,1, _xx,_yy, _ww,_hh, c_white,_alph2);
	
	self.DrawText(textColor);
	
	return true;
}
