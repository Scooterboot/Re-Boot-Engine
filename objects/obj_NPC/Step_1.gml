/// @description 

if(setOldPoses == 0)
{
	for(var i = 0; i < 10; i++)
	{
		oldPosX[i] = x;
		oldPosY[i] = y;
	}
	setOldPoses = 1;
}