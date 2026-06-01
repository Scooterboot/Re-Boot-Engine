
function draw_scribble_shadow(_scrib, _x, _y, _col = c_white, _alph = 1, _shadCol = c_black, _shadAlph = 1, _shadOffX = 1, _shadOffY = 1)
{
	///@param scribble
	///@param x
	///@param y
	///@param color=white
	///@param alpha=1
	///@param shadowColor=black
	///@param shadowAlpha=1
	///@param shadowX=1
	///@param shadowY=1
	
	_scrib.blend(_shadCol,_shadAlph).draw(_x+_shadOffX, _y+_shadOffY);
	_scrib.blend(_col,_alph).draw(_x, _y);
}

function draw_ScribbleJr_shadow(_scribJr, _x, _y, _col = c_white, _alph = 1, _shadCol = c_black, _shadAlph = 1, _shadOffX = 1, _shadOffY = 1)
{
	///@param ScribbleJr
	///@param x
	///@param y
	///@param color=white
	///@param alpha=1
	///@param shadowColor=black
	///@param shadowAlpha=1
	///@param shadowX=1
	///@param shadowY=1
	
	_scribJr.Draw(_x+_shadOffX, _y+_shadOffY, _shadCol, _shadAlph);
	_scribJr.Draw(_x, _y, _col, _alph);
}
