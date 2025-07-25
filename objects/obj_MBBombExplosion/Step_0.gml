/// @description Code
if(explode <= 0)
{
	self.TileInteract(x,y);
	self.TileInteract(x-sourceVelX,y-sourceVelY);
	
	scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,4);
	
	explode++;
}
else
{
	instance_destroy();
}