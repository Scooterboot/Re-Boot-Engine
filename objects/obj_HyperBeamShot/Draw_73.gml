/// @description Set old values
event_inherited();

if(!global.GamePaused())
{
	xstart += speed_x;
	ystart += speed_y;
	
	for(var i = 0; i < 11; i++)
	{
		oldPosX[i] += speed_x;
		oldPosY[i] += speed_y;
	}
}