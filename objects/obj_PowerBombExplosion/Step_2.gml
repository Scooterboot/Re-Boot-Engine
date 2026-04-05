if(global.GamePaused())
{
	exit;
}

if(dmgDelay <= 0)
{
	self.DamageBoxes();
}
else
{
	dmgDelay--;
}
self.IncrInvFrames();

if(scaleTimer >= 75)
{
	instance_destroy();
	instance_destroy(distort);
}