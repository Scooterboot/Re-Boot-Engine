
if(global.GamePaused())
{
	exit;
}

if(grappleState == GrappleState.None && impacted < 2)
{
	self.DamageBoxes();
	self.IncrInvFrames();
}