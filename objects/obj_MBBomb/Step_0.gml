/// @description Behavior

if(global.GamePaused())
{
	exit;
}

bombTimer--;
if(bombTimer >= 20)
{
	image_speed = 0.25;
}
else
{
	image_speed = 0.5;
}

if(spreadType != -1)
{
	if(spreadType == 0)
	{
		velY = min(velY+0.25,10);
	}
	if(spreadType == 1)
	{
		if(velX > 0)
		{
			velX = max(velX-spreadFrict,0);
		}
		if(velX < 0)
		{
			velX = min(velX+spreadFrict,0);
		}
			
		if(velY > 0)
		{
			velY = max(velY-spreadFrict,0);
		}
		if(velY < 0)
		{
			velY = min(velY+spreadFrict,0);
		}
	}
	if(spreadType == 2)
	{
		velX = lengthdir_x(spreadSpeed,spreadDir);
		velY = lengthdir_y(spreadSpeed,spreadDir);
		spreadSpeed = max(spreadSpeed-spreadFrict,0);
	}
	
	self.Collision_Normal(velX,velY,false);
}
else
{
	if(bombTimer <= 40 && dmgScale == 0)
	{
		damage *= 3;
		dmgScale = 1;
	}
	if(bombTimer <= 20 && dmgScale == 1)
	{
		damage *= 2.5;
		dmgScale = 2;
	}
	if(bombTimer <= 1 && dmgScale == 2)
	{
		damage /= 0.75;
		dmgScale = 3;
	}
}

self.DamageBoxes();

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
				/*player.bombJumpX = player.velX + (sign(num) * min(abs(num*1.5),2.75));
				if(player.liquidState > 0)
				{
					player.bombJumpX /= 3;
				}*/
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