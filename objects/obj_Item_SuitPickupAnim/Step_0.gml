/// @description Logic

if(global.gamePaused)
{
	exit;
}

if(instance_exists(obj_Player))
{
	obj_Player.state = State.Elevator;
	if(obj_Player.x < x)
	{
		obj_Player.x = min(obj_Player.x+1,x);
	}
	else
	{
		obj_Player.x = max(obj_Player.x-1,x);
	}
	if(obj_Player.y < y)
	{
		obj_Player.y = min(obj_Player.y+1,y);
	}
	else
	{
		obj_Player.y = max(obj_Player.y-1,y);
	}
	if(animCounter == animCounterMax)
	{
		obj_Player.hasSuit[animType] = true;
		obj_Player.suit[animType] = true;
	}
}
if(animCounter == 1)
{
	audio_play_sound(snd_SuitFlash,0,false);
}
animCounter++;
if(animCounter > animCounterMax*2)
{
	instance_destroy();
}