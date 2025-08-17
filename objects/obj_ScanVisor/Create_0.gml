
scanAnim = 1;
scanAlpha = 0;

kill = false;

scanSound = noone;

darkSurf = noone;

function GetRoomX()
{
	return x + camera_get_view_x(view_camera[0]);
}
function GetRoomY()
{
	return y + camera_get_view_y(view_camera[0]);
}