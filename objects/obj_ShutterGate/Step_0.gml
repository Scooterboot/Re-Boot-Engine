/// @description 
if(global.gamePaused)
{
	exit;
}

if(state == ShutterState.Opening)
{
	shutterH = max(shutterH - sSpeed, 0);
	if(shutterH <= 0)
	{
		state = ShutterState.Opened;
	}
}
if(state == ShutterState.Closing)
{
	if(overrideHeight <= 0)
	{
		var shutterHMax = 0;
		while(!shutter_place_meeting(x+lengthdir_x(shutterHMax+1,image_angle-90),y+lengthdir_y(shutterHMax+1,image_angle-90)) && shutterHMax < room_height)
		{
			shutterHMax++;
		}
		shutterH = min(shutterH + sSpeed, shutterHMax);
		if(shutterH >= shutterHMax)
		{
			state = ShutterState.Closed;
		}
	}
	else
	{
		shutterH = min(shutterH + sSpeed, overrideHeight);
		if(shutterH >= overrideHeight)
		{
			state = ShutterState.Closed;
		}
	}
}

if(instance_exists(mBlock))
{
	mBlock.isSolid = false;
	mBlock.image_yscale = -(scr_round(shutterH+4)/16);
	mBlock.UpdatePosition(x+lengthdir_x(shutterH+16,image_angle-90),y+lengthdir_y(shutterH+16,image_angle-90));
	mBlock.isSolid = true;
}