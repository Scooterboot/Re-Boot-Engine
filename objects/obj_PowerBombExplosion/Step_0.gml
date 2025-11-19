/// @description Code
if(global.GamePaused())
{
	exit;
}

alpha2 = abs((scaleTimer/2) - 75)/75;
pSpeed = abs(scaleTimer - 75)/75;
scaleTimer += max(3*pSpeed,0.1);
if(scaleTimer >= 60)
{
	pAlpha = (75 - scaleTimer)/15;
}

self.TileInteract(x,y);

scale = scaleMult*scaleTimer;
image_xscale = scale;
image_yscale = scale;
image_alpha = pAlpha*alpha2 * 0.5;

self.DamageBoxes();
self.IncrInvFrames();

var x1 = bb_left(0),
	y1 = bb_top(0),
	x2 = bb_right(0),
	y2 = bb_bottom(0);
distort.left = x+x1*1.1;
distort.right = x+x2*1.1;
distort.top = y+y1*1.1;
distort.bottom = y+y2*1.1;
distort.alpha = image_alpha;
distort.spread = 0.85;
distort.width = 0.75;

if(scaleTimer >= 75)
{
	instance_destroy();
	instance_destroy(distort);
}