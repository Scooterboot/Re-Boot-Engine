/// @description Set position

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	screenScale = obj_Display.screenScale;

x = (mouse_x - xx) * (window_get_width() / (global.zoomResWidth*screenScale)) - global.screenX/screenScale;
y = (mouse_y - yy) * (window_get_height() / (global.zoomResHeight*screenScale)) - global.screenY/screenScale;

posX = x + xx;
posY = y + yy;