if(global.GamePaused())
{
	exit;
}

if(dmgDelay <= 0)
{
	self.DamageBoxes();
}
else
{
	dmgDelay--;
}
self.IncrInvFrames();

if(bombTimer <= 0 || impacted > 0)
{
	mask_index = sprt_MBBombExplosion;
	var player = collision_circle(x,y,(bb_right()-bb_left())/3,obj_Player,false,true);
	if(instance_exists(player))
	{
		var flag = false;
		with(player)
		{
			if(place_meeting(x,y,obj_MorphLauncher) && state == State.Morph && grounded && velY >= 0 && !SpiderActive())
			{
				flag = true;
			}
			if(state == State.BallSpark && shineLauncherStart > 0)
			{
				flag = true;
			}
		}
		if(!flag)
		{
			var num = player.x - x;
			if(abs(num) > 1)
			{
				player.bombJumpX = player.bombXSpeed[player.liquidState] * sign(num);
			}
			player.bombJump = player.bombJumpMax[player.liquidState];
		}
	}
	if(spreadType == 2)
	{
		audio_stop_sound(snd_Explode);
	}
	instance_destroy();
}