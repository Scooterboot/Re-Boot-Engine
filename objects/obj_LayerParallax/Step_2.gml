/// @description Parallax

if(!instance_exists(obj_Camera))
{
	exit;
}

var camx = camera_get_view_x(view_camera[0]),
	camy = camera_get_view_y(view_camera[0]),
	camw = global.resWidth,
	camh = global.resHeight;

posX += layer_get_hspeed(layerID) * (!global.gamePaused);
posY += layer_get_vspeed(layerID) * (!global.gamePaused);

if(multX > 0)
{
	if(string_count("right",alignment) > 0)
	{
		layer_x(layerID, posX - scr_round(((room_width-camw) - camx) * multX));
	}
	else
	{
		layer_x(layerID, posX + scr_round(camx * multX));
	}
}

if(multY > 0)
{
	if(string_count("bottom",alignment) > 0)
	{
		layer_y(layerID, posY - scr_round(((room_height-camh) - camy) * multY));
	}
	else
	{
		layer_y(layerID, posY + scr_round(camy * multY));
	}
}
