/// @description 
if(!init)
{
	if(initialH <= 0)
	{
		while(!shutter_place_meeting(x+lengthdir_x(initialH+1,image_angle-90),y+lengthdir_y(initialH+1,image_angle-90)) && initialH < room_width+room_height)
		{
			initialH++;
		}
	}
	init = true;
}

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
	var hDest = initialH;
	if(overrideHeight > 0)
	{
		hDest = overrideHeight;
	}
	var shutterHMax = 0;
	while(!shutter_place_meeting(x+lengthdir_x(shutterHMax+1,image_angle-90),y+lengthdir_y(shutterHMax+1,image_angle-90)) && shutterHMax < hDest)
	{
		shutterHMax++;
	}
	if(shutterH < shutterHMax)
	{
		shutterH = min(shutterH + sSpeed, shutterHMax);
	}
	if((shutterH >= hDest && !stopAnywhere) ||
		(shutterH >= shutterHMax && stopAnywhere))
	{
		state = ShutterState.Closed;
	}
}

stuck = false;
if(instance_exists(mBlock))
{
	mBlock.isSolid = false;
	mBlock.image_yscale = -(scr_round(shutterH+4)/16);
	mBlock.UpdatePosition(x+lengthdir_x(shutterH+16,image_angle-90),y+lengthdir_y(shutterH+16,image_angle-90),!ignoreEntities);
	mBlock.isSolid = true;
	
	var sh = shutterH;
	
	shutterH = max(point_distance(x,y,mBlock.x,mBlock.y)-16,0);
	mBlock.image_yscale = -(scr_round(shutterH+4)/16);
	
	if(state == ShutterState.Closing && shutterH < sh)
	{
		stuck = true;
	}
}