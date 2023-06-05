/// @description Parallax

if(!instance_exists(obj_Camera))
{
	exit;
}

var camx = obj_Camera.x,//camera_get_view_x(view_camera[0]),
	camy = obj_Camera.y,//camera_get_view_y(view_camera[0]),
	camw = global.resWidth,
	camh = global.resHeight;

bgPosX += layer_get_hspeed(bgLayerID);
bgPosY += layer_get_vspeed(bgLayerID);

if(multX > 0)
{
	if(string_count("right",alignment) > 0)
	{
		layer_x(bgLayerID, bgPosX - scr_round(((room_width-camw) - camx) * multX));
	}
	else
	{
		layer_x(bgLayerID, bgPosX + scr_round(camx * multX));
	}
}

if(multY > 0)
{
	if(string_count("bottom",alignment) > 0)
	{
		layer_y(bgLayerID, bgPosY - scr_round(((room_height-camh) - camy) * multY));
	}
	else
	{
		layer_y(bgLayerID, bgPosY + scr_round(camy * multY));
	}
}
