/// @description Draw messages

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight;

if(instance_exists(obj_SaveStation) && obj_SaveStation.saving > 120)
{
	messageCounter = min(messageCounter+0.1,1);
	messageType = 0;
}
else
{
	messageCounter = max(messageCounter-0.05,0);
}

if(messageCounter > 0)
{
	draw_set_font(GUIFont);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	var str = message[messageType];
	scr_DrawOptionText(xx+(ww/2),yy+(hh/2),str,c_white,messageCounter,0,c_black,0);
}