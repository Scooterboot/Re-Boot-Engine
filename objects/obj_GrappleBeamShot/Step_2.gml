
if(global.GamePaused())
{
	exit;
}

if(grappleState == GrappleState.None && impacted < 2)
{
	self.DamageBoxes();
	self.IncrInvFrames();
}

if(impacted == 1)
{
	self.OnImpact(x,y,dmgImpacted);
}
	
if(impacted > 0)
{
	if(impacted > 1)
	{
		instance_destroy();
	}
	impacted += 1;
}
