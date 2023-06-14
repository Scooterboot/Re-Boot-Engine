/// @description 
if(global.gamePaused)
{
	exit;
}

rot += 3;

x = xstart + lengthdir_x(64,rot);
y = ystart + lengthdir_y(64,rot);

UpdatePositions();