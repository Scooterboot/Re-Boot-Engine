function draw_rectangle_betterOutline(_x1, _y1, _x2, _y2)
{
	var x1 = min(_x1+1, _x2),
		x2 = max(_x1+1, _x2),
		y1 = min(_y1+1, _y2),
		y2 = max(_y1+1, _y2);
	
	draw_line(x1-1, y1, x2, y1); // top
	draw_line(x1, y2, x2-1, y2); // bottom
	draw_line(x1, y1, x1, y2); // left
	draw_line(x2, y1, x2, y2); // right
}