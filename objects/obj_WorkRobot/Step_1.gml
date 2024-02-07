/// @description 
event_inherited();

if(PauseAI())
{
    exit;
}

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

grounded = (entity_place_collide(0,1) || (bbox_bottom+1) >= room_height);// && velY == 0);
fGrav = grav[instance_exists(liquid)];

if(!grounded)
{
    velY = min(velY+fGrav, maxGrav);
}

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,16,16,true);

EntityLiquid_Large(x-xprevious,y-yprevious);


for(var i = 0; i < array_length(mBlocks); i++)
{
	mBlocks[i].isSolid = false;
}
var xdiff = LerpArray(topOffsetX,scr_floor(max(frame-3,0)),true) * dir;
for(var i = 0; i < array_length(mBlocks); i++)
{
	mBlockOffX[i] = mBlockOffX_default[i];
	mBlockOffX[i] += xdiff * (1 - (max(i-3,0) / 6));
	
	var xx = x + mBlockOffX[i],
		yy = y + mBlockOffY[i];
	mBlocks[i].UpdatePosition(xx,yy);
}
for(var i = 0; i < array_length(mBlocks); i++)
{
	mBlocks[i].isSolid = true;
}

eyePalIndex += 0.1 * eyePalNum;
if(eyePalIndex <= 0)
{
	eyePalNum = 1;
}
if(eyePalIndex >= 3)
{
	eyePalNum = -1;
}