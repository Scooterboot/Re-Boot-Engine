function draw_rectangle_betterOutline(_x1, _y1, _x2, _y2)
{
	var x1 = min(_x1+1, _x2),
		x2 = max(_x1+1, _x2),
		y1 = min(_y1+1, _y2),
		y2 = max(_y1+1, _y2);
	
	//draw_line(x1-1, y1, x2, y1); // top
	//draw_line(x1, y2, x2-1, y2); // bottom
	//draw_line(x1, y1, x1, y2); // left
	//draw_line(x2, y1, x2, y2); // right
	var _a = draw_get_alpha(),
		_c = draw_get_colour();
	var _pos = [
		[x1, y1, x2, y1],
		[x1, y2, x2, y2],
		[x1, y1+1, x1, y2-1],
		[x2, y1+1, x2, y2-1]];
	
	for(var i = 0; i < array_length(_pos); i++)
	{
		var _x = _pos[i][0],
			_y = _pos[i][1],
			_w = _pos[i][2]-_x,
			_h = _pos[i][3]-_y;
		draw_sprite_stretched_ext(sprt_ParticlePixel,0, _x-1, _y-1, _w+1, _h+1, _c,_a);
	}
}