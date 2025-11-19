/// @description 

if(!self.PauseAI())
{
	velX = mSpeed*dir;

	var moveX = x-oldPosX[0],
		moveY = y-oldPosY[0];

	var player = obj_Player;
	if (instance_exists(player) && (player.bb_bottom() <= self.bb_top() || player.bb_bottom() <= (self.bb_top()-moveY)) &&
		player.grounded && (place_meeting(x,y-2,player) || place_meeting(x-moveX,y-moveY-2,player)))
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

event_inherited();