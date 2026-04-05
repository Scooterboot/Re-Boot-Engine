/// @description 
if(global.GamePaused())
{
	exit;
}

if(isExploProj)
{
	if(!tilesHit)
	{
		self.TileInteract(x,y);
		self.TileInteract(x-sourceVelX,y-sourceVelY);
		tilesHit = true;
	}
}
else
{
	event_inherited();
	self.EntityLiquid(1,x-xprevious,y-yprevious,true,false,true);
}