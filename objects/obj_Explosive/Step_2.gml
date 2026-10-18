if(global.GamePaused())
{
	exit;
}

if(isExploProj)
{
	if(explode <= 5)
	{
		self.DamageBoxes();
		self.IncrInvFrames();
	
		explode++;
	}
	else
	{
		instance_destroy();
	}
}
else
{
	event_inherited();
}