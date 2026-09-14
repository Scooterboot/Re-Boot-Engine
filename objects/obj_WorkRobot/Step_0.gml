
if(!self.PauseAI())
{
	if(state == WorkRobotState.Idle)
	{
		currentSprt = sprt_WorkRobot_Idle;
		currentFrame = idleFrame;
		
		walkFrame = 12*idleFrame;
		velX = 0;
		wallCol = 0;
		
		ai[0]++;
		if(ai[0] > 180)
		{
			state = WorkRobotState.Moving;
		}
		// WIP
	}
	if(state == WorkRobotState.Moving)
	{
		currentSprt = sprt_WorkRobot_Walk;
		
		var fspeed = mSpeed * movingDir * facingDir;
		walkFrame = scr_wrap(walkFrame + fspeed, 0, 24);
		currentFrame = scr_floor(walkFrame);
		
		if(currentFrame == 7 || currentFrame == 19)
		{
			if(sndPlayedAt != currentFrame)
			{
				audio_play_sound(snd_WorkRobot,0,false);
				sndPlayedAt = currentFrame;
			}
		}
		else
		{
			sndPlayedAt = 0;
		}
		
		if(movedAtFrame != currentFrame)
		{
			velX = moveXSeq[currentFrame] * movingDir;
			movedAtFrame = currentFrame;
		}
		else
		{
			velX = 0;
		}
		
		if(wallCol != 0)
		{
			self.ChangeFacingDir(-wallCol);
			movingDir = facingDir;
			wallCol = 0;
		}
		
		//if(!self.entity_place_collide(12*facingDir, 2))
		//{
		//	velX = 0;
		//	self.TryChangeToIdleState();
		//}
		
		// WIP
	}
	
	grounded = (self.entity_place_collide(0,1) || (self.bb_bottom()+1) >= room_height);// && velY == 0);
	fGrav = grav[instance_exists(liquid)];

	if(!grounded)
	{
	    velY = min(velY+fGrav, fallSpeedMax);
	}

	fVelX = velX;
	fVelY = velY;
	self.Collision_Normal(fVelX,fVelY,true);

	self.EntityLiquid_Large(x-xprevious,y-yprevious);
}

var xdiff = self.GetTopXOffset();
mBlockOffset[0].X = xdiff;
if(sign(xdiff) != 0)
{
	mBlocks[0].image_xscale = sign(xdiff);
	mBlocks[1].image_xscale = sign(xdiff);
}

self.UpdateMovingTiles();

eyePalIndex += 0.1 * eyePalNum;
if(eyePalIndex <= 0)
{
	eyePalNum = 1;
}
if(eyePalIndex >= 3)
{
	eyePalNum = -1;
}

// Inherit the parent event
event_inherited();
