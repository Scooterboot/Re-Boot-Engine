/// @description 

if(setOldPoses > 0)
{
	for(var i = array_length(oldPosX)-1; i > 0; i--)
	{
		oldPosX[i] = oldPosX[i-1];
		oldPosY[i] = oldPosY[i-1];
	}
	oldPosX[0] = x;
	oldPosY[0] = y;
	setOldPoses = 2;
}

shiftX = 0;
shiftY = 0;
movedVelX = 0;
movedVelY = 0;

if(dead)
{
    NPCDeath(x+deathOffsetX,y+deathOffsetY);
}