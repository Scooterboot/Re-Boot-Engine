/// @description Set old values

if(!global.GamePaused())
{
	if(!oldPositionsSet)
	{
		for(var i = 0; i < 11; i++)
		{
			oldPosX[i] = x;
			oldPosY[i] = y;
		}
		for(var i = 0; i < 11; i++)
		{
			oldRot[i] = image_angle;
		}
		oldPositionsSet = true;
	}
    
	for(var i = 10; i > 0; i--)
	{
		oldPosX[i] = oldPosX[i - 1];
		oldPosY[i] = oldPosY[i - 1];
	}
	oldPosX[0] = x;
	oldPosY[0] = y;
}
