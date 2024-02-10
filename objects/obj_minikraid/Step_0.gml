/// @description 
if(PauseAI())
{
	exit;
}
event_inherited();

if(instance_exists(obj_Player))
{
	var dirDest = sign(obj_Player.x - x);
	if(dirDest != 0)
	{
		dir = dirDest;
	}
}

if(moveDir == 0)
{
	velX = 0;
	
	moveCounter++;
	if(moveCounter > 40)
	{
		if(prevMoveDir == 0)
		{
			moveDir = irandom(1) == 0 ? 1 : -1;
		}
		else
		{
			moveDir = -sign(prevMoveDir);
		}
		moveCounter = irandom(30);
	}
	
	walkFrameCounter = 0;
}
else
{
	velX = moveSpeed*moveDir;


	var walkNum = moveDir*dir;
	walkFrameCounter++;
	if(walkFrameCounter > 2)
	{
		walkFrame = scr_wrap(walkFrame+walkNum,0,16);
		moveCounter2++;
		walkFrameCounter = 0;
	}
	if(moveCounter2 >= 16)
	{
		prevMoveDir += moveDir;
		moveDir = 0;
		moveCounter2 = 0;
	}
}

for(var i = 0; i < 3; i++)
{
	spikeFire[i]++;
	if(spikeFire[i] > spikeFireMax)
	{
		var proj = instance_create_depth(x+spikePosX[i]*dir,y+spikePosY[i],depth+1,obj_MiniKraid_Spike);
		proj.image_xscale = dir;
		proj.velX = 3*dir;
		
		if(scr_WithinCamRange())
		{
			audio_stop_sound(snd_MiniKraid_SpikeShoot);
			audio_play_sound(snd_MiniKraid_SpikeShoot,0,false);
		}
		
		spikeFire[i] = irandom_range(40,70) - 20*abs(i-1);
	}
}

if(instance_exists(obj_Player) && point_distance(x,y,obj_Player.x,obj_Player.y) <= 128 && spitCounter < 80)
{
	spitCounter++;
}
if(spitCounter >= 80 && spitCounter < 85)
{
	mouthFrameNum = 1;
	
	if(mouthFrame >= 2 && !spitFired)
	{
		for(var i = 0; i < 3; i++)
		{
			var spDir = 55 + 10*i + irandom(10),
				spSpeed = 6;
			var spVelX = lengthdir_x(spSpeed,spDir)*1.5,
				spVelY = lengthdir_y(spSpeed,spDir);
			
			var proj = instance_create_depth(x,y-17,depth+1,obj_MiniKraid_Spit);
			proj.velX = spVelX*dir;
			proj.velY = spVelY;
		}
		
		audio_play_sound(snd_MiniKraid_Roar,0,false);
		
		spitFired = true;
	}
	else if(spitFired)
	{
		spitCounter++;
	}
}
else if(spitCounter >= 85)
{
	mouthFrameNum = -1;
	if(mouthFrame <= 0)
	{
		spitCounter = irandom(3)*5;
	}
}
else
{
	mouthFrameNum = -1;
	spitFired = false;
}

//if((mouthFrame < 2 && mouthFrameNum == 1) || (mouthFrame > 0 && mouthFrameNum == -1))
//{
	mouthFrameCounter++;
//}
if(mouthFrameCounter > 5)
{
	mouthFrame = clamp(mouthFrame+mouthFrameNum, 0, 2);
	mouthFrameCounter = 0;
}

handFrameCounter++;
if(handFrameCounter > 45)
{
	handFrame = scr_wrap(handFrame+1,0,2);
	handFrameCounter = 0;
}

tailFrameCounter++;
if(tailFrameCounter > 4)
{
	if(moveDir == 0)
	{
		tailFrame = max(tailFrame-1,0);
		tailFrame2 = 0;
	}
	else
	{
		tailFrame2 = scr_wrap(tailFrame2+1,0,4);
		tailFrame = tailFrameSequence[tailFrame2];
	}
	tailFrameCounter = 0;
}

velY = min(velY+fGrav,fallSpeedMax);

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,true);