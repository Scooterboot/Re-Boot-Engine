/// @description 

event_inherited();

if(!self.PauseAI())
{
	velX = mSpeed*dir;

	var player = obj_Player;
	if (grav > 0 && instance_exists(player) && (player.bb_bottom(player.y) <= self.bb_top(y) || player.bb_bottom(player.yprevious) <= self.bb_top(yprevious)) &&
		player.grounded && (place_meeting(x,y-2,player) || place_meeting(xprevious,yprevious-2,player)))
	{
		gravCounter++;
		if(gravCounter > gravCounterMax)
		{
			velY = min(velY+grav,fallSpeedMax);
		}
	}
	else
	{
		gravCounter = 0;
		velY -= lift;
	}
	var liftMax = min(y-yStart,liftSpeedMax);
	velY = max(velY,-liftMax);

	if(velY < 0)
	{
		frameCounter++;
		if(frameCounter > 4)
		{
			frame++;
			frameCounter = 0;
		}
		frame = scr_wrap(frame,4,6)
		image_index = frame-1;
	}
	else
	{
		frameCounter++;
		if(frameCounter > 4)
		{
			frame++;
			frameCounter = 0;
		}
		frame = scr_wrap(frame,0,4);
		image_index = frameSeq[frame];
	}

	image_xscale = dir;
}