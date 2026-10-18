if(global.GamePaused())
{
	exit;
}

self.DamageBoxes();
self.IncrInvFrames();

if(scaleTimer >= 75)
{
	instance_destroy();
	instance_destroy(distort);
}