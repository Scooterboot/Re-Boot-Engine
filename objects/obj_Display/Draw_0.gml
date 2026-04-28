/// @description Draw black outside room

var camX = global.cameraX,
	camY = global.cameraY,
	camW = global.resWidth,
	camH = global.resHeight;

if (camX < 0 || camY < 0)
{
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	var x1 = camX,
		x2 = 0;
	draw_rectangle(x1,camY-2,x2,camY+camH+2,false);
	
	var y1 = camY,
		y2 = 0;
	draw_rectangle(camX-2,y1,camX+camW+2,y2,false);
	
	draw_set_color(c_white);
}
if (camX+camW > room_width || camY+camH > room_height)
{
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	var x1 = room_width,
		x2 = camX+camW;
	draw_rectangle(x1,camY-2,x2,camY+camH+2,false);
	
	var y1 = room_height,
		y2 = camY+camH;
	draw_rectangle(camX-2,y1,camX+camW+2,y2,false);
	
	draw_set_color(c_white);
}
