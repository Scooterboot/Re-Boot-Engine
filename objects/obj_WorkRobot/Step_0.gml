// Inherit the parent event
event_inherited();

if(!PauseAI())
{
    var fspeed = mSpeed;
	if(frame < 3)
	{
		frame += fspeed;
	}
	else
	{
		frame = scr_wrap(frame+fspeed,3,27);
	}
	currentFrame = scr_floor(frame);

	if(currentFrame == 11 || currentFrame == 23)
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
		velX = moveXSeq[currentFrame]*dir;
		movedAtFrame = currentFrame;
	}
	else
	{
		velX = 0;
	}

	grounded = (entity_place_collide(0,1) || (bb_bottom()+1) >= room_height);// && velY == 0);
	fGrav = grav[instance_exists(liquid)];

	if(!grounded)
	{
	    velY = min(velY+fGrav, maxGrav);
	}

	fVelX = velX;
	fVelY = velY;
	Collision_Normal(fVelX,fVelY,true);

	EntityLiquid_Large(x-xprevious,y-yprevious);
}

//var xdiff = LerpArray(topOffsetX,scr_floor(max(frame-3,0)),true) * dir;
var xdiff = scr_round(LerpArray(topOffsetX,max(frame-3.5,0),true) * dir);
for(var i = 0; i < array_length(mBlocks); i++)
{
	mBlockOffset[i].X = mBlockOffX_default[i];
	mBlockOffset[i].X += xdiff * clamp(1 - (max(i-3,0) / 5),0,1);
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