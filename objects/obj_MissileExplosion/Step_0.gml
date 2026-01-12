if(explode <= 5)
{
	if(explode <= 0)
	{
		self.TileInteract(x,y);
		self.TileInteract(x-sourceVelX,y-sourceVelY);
	}
	
	self.DamageBoxes();
	
	explode++;
}
else
{
	instance_destroy();
}