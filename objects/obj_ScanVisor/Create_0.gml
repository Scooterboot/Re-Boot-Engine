
scanAnim = 1;
scanAlpha = 0;

kill = false;

scanSound = noone;

darkSurf = noone;

function GetRoomX()
{
	return global.cameraX + (x * global.zoomScale);
}
function GetRoomY()
{
	return global.cameraY + (y * global.zoomScale);
}