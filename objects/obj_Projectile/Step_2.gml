/// @description Deal damage & expiration logic

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


if(impacted == 1 && !reflected)
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

if(timeLeft > -1)
{
	if(timeLeft <= 0)
	{
		instance_destroy();
	}
	else
	{
		timeLeft--;
	}
}

var _camFlag = ignoreCamera;
if(x < 0 || x > room_width || y < 0 || y > room_height)
{
	_camFlag = false;
}
if(!scr_WithinCamRange(-1,-1,extCamRange) && !_camFlag)
{
	outsideCam++;
	if(outsideCam > 1)
	{
		instance_destroy();
	}
}