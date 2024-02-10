/// @description Behavior

if(global.gamePaused)
{
	exit;
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
	
	Collision_Normal(velX,velY,false);
}

scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,4);

bombTimer--;
if(bombTimer >= 20)
{
	image_speed = 0.25;
}
else
{
	image_speed = 0.5;
}

if(bombTimer <= 0 || impacted > 0)
{
	mask_index = sprt_MBBombExplosion;
	var player = collision_circle(x,y,(bbox_right-bbox_left)/3,obj_Player,false,true);
	if(instance_exists(player))
	{
		var flag = false;
		with(player)
		{
			if(place_meeting(x,y,obj_MorphLauncher) && state == State.Morph && grounded && velY >= 0 && !spiderBall)
			{
				flag = true;
			}
			if(state == State.BallSpark && shineLauncherStart > 0)
			{
				flag = true;
			}
		}
		//if(!player.entity_place_collide(0,-11) || ((player.state != State.Crouch || !player.grounded) && player.morphFrame <= 0))
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