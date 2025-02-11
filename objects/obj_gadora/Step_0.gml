/// @description 
//event_inherited();
if(PauseAI())
{
	exit;
}

var player = noone,
	playerDetected = false;
if(instance_exists(obj_Player))
{
	player = obj_Player;
}
var checkX = x+lengthdir_x(16,image_angle)*image_xscale,
	checkY = y+lengthdir_y(16,image_angle)*image_xscale;
if (point_distance(x,y,player.x,player.y) <= 150 && 
	!collision_line(checkX,checkY,player.x,player.y,global.colArr_Solid,true,true))
{
	for(var i = 16; i < 150; i += 64)
	{
		checkX = x+lengthdir_x(i,image_angle)*image_xscale;
		checkY = y+lengthdir_y(i,image_angle)*image_xscale;
		if(collision_rectangle(checkX-32,checkY-32,checkX+32,checkY+32,player,false,true))
		{
			playerDetected = true;
			break;
		}
	}
}

DamagePlayer();

if(!dead)
{
	if(eyeState == 0)
	{
		if(playerDetected)
		{
			eyeTimer++;
			if(eyeTimer > 60)
			{
				//eyeState = choose(1,2);
				eyeState = 1;
				if(irandom(2) <= eyeChance)
				{
					eyeState = 2;
				}
				eyeTimer = 0;
			}
		}
		else
		{
			eyeTimer = min(eyeTimer,0);
		}
	
		eyeFrameCounter++;
		if(eyeFrameCounter > 4)
		{
			eyeFrame = clamp(eyeFrame-1,0,2);
			eyeFrameCounter = 0;
		}
	}
	if(eyeState == 1)
	{
		eyeTimer++;
		if(eyeTimer > 180 || !playerDetected)
		{
			eyeState = 0;
			eyeTimer = -30*playerDetected;
			eyeChance++;
		}
	
		eyeFrameCounter++;
		if(eyeFrameCounter > 4)
		{
			eyeFrame = clamp(eyeFrame+1,0,2);
			eyeFrameCounter = 0;
		}
		eyeVuln = true;
	}
	else
	{
		eyeVuln = false;
	}
	if(eyeState == 2)
	{
		if(eyeTimer == 0)
		{
			audio_play_sound(snd_Gadora_Charge,0,false);
		}
	
		eyeTimer++;
	
		if(eyeTimer == 60)
		{
			var proj = instance_create_depth(x,y,depth-1,obj_Gadora_EyeBeam);
			proj.damage = damage*2;
			proj.velX = lengthdir_x(5,image_angle)*image_xscale;
			proj.velY = lengthdir_y(5,image_angle)*image_xscale;
			proj.image_angle = image_angle;
			if(image_xscale < 0)
			{
				proj.image_angle += 180;
			}
			audio_play_sound(snd_Gadora_EyeBeam,0,false);
		}
		if(eyeTimer > 65)
		{
			eyeState = 0;
			eyeTimer = -30;
			eyeChance = max(eyeChance-1,0);
		}
	
		eyeFrameCounter++;
		if(eyeFrameCounter > 4)
		{
			eyeFrame++;
			if(eyeFrame >= 2)
			{
				eyeFrame = scr_wrap(eyeFrame,3,5);
			}
			eyeFrameCounter = 0;
		}
	}
}
else
{
	eyeFrameCounter++;
	if(eyeFrameCounter > 2)
	{
		eyeFrame = clamp(eyeFrame+eyeFrameNum,0,3);
		if(eyeFrame <= 0)
		{
			eyeFrameNum = 1;
		}
		if(eyeFrame >= 3)
		{
			eyeFrameNum = -1;
		}
		eyeFrameCounter = 0;
	}
}

var fcMax = 8;
if(playerDetected || dead)
{
	fcMax = 4;
}
frameCounter++;
if(frameCounter > fcMax)
{
	frame = clamp(frame+frameNum,0,2);
	if(frame <= 0)
	{
		frameNum = 1;
	}
	if(frame >= 2)
	{
		frameNum = -1;
	}
	frameCounter = 0;
}