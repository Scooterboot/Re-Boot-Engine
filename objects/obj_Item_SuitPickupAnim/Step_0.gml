/// @description Logic

if(global.GamePaused())
{
	exit;
}

if(instance_exists(player))
{
	player.velX = 0;
	player.velY = 0;
	if(player.CanChangeMask(mask_Player_Stand))
	{
		player.ChangeState(State.Elevator,AnimState.Stand,,mask_Player_Stand,false,true);
	}
	if(player.position.X != x)
	{
		var _shX = x-player.position.X;
		player.shiftX = min(abs(_shX),1) * sign(_shX);
	}
	if(player.position.Y != y)
	{
		var _shY = y-player.position.Y;
		player.shiftY = min(abs(_shY),1) * sign(_shY);
	}
	
	if(animCounter == animCounterMax)
	{
		player.hasItem[animType] = true;
		player.item[animType] = true;
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