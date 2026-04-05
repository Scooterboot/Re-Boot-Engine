if(global.GamePaused())
{
	exit;
}

if(isExploProj)
{
	if(explode <= 5)
	{
		if(dmgDelay <= 0)
		{
			self.DamageBoxes();
		}
		else
		{
			dmgDelay--;
		}
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