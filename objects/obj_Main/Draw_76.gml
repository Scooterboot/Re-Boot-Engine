/// @description OOB black background

var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]),
	camW = global.resWidth,
	camH = global.resHeight;

if (camX < 0 || camX+camW > room_width ||
	camY < 0 || camY+camH > room_height)
{
	draw_set_alpha(1)
	draw_set_color(c_black);
	
	var x1 = room_width,
		x2 = camX+camW;
	if(camX < 0)
	{
		x1 = camX;
		x2 = 0;
	}
	draw_rectangle(x1,camY-2,x2-1,camY+camH+2,false);
	
	var y1 = room_height,
		y2 = camY+camH;
	if(camY < 0)
	{
		y1 = camY;
		y2 = 0;
	}
	draw_rectangle(camX-2,y1,camX+camW+2,y2-1,false);
	
	draw_set_color(c_white);
}