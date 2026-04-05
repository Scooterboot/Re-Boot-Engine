/// @description 

if(!global.GamePaused())
{
	self.DamageBoxes();
	self.IncrInvFrames();
}

shiftX = 0;
shiftY = 0;
movedVelX = 0;
movedVelY = 0;

if(dead)
{
    self.NPCDeath(x+deathOffsetX,y+deathOffsetY);
}