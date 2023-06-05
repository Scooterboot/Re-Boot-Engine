/// @description Behavior

if(global.gamePaused)
{
	exit;
}

if(spreadType != -1)
{
	if(spreadType < 2)
	{
		if(spreadType == 0)
		{
			if(place_collide(0,1))
			{
				var frict = 0.2;
				
				if(velX > 0)
				{
					velX = max(velX-frict,0);
				}
				if(velX < 0)
				{
					velX = min(velX+frict,0);
				}
			}
			
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
		
		if(place_collide(velX,0) && abs(velX) >= 0.5)
		{
			velX *= -0.25;
		}
		
		if(place_collide(velX,0))
		{
			var xspeed = velX;
			while(!place_collide(sign(velX),0) && xspeed > 0)
			{
				x += sign(velX);
				xspeed--;
			}
			velX = 0;
		}
		x += velX;
		
		if(place_collide(0,velY) && abs(velY) >= 0.5)
		{
			velY *= -0.25;
		}
		
		if(place_collide(0,velY))
		{
			var yspeed = velY;
			while(!place_collide(0,sign(velY)) && yspeed > 0)
			{
				y += sign(velY);
				yspeed--;
			}
			velY = 0;
		}
		y += velY;
	}
	else if(spreadType == 2)
	{
		var speedX = lengthdir_x(spreadSpeed,spreadDir),
			speedY = lengthdir_y(spreadSpeed,spreadDir);
		if(place_collide(speedX,speedY))
		{
			var sSpeed = max(abs(speedX),abs(speedY));
			while(!place_collide(sign(speedX),sign(speedY)) && sSpeed > 0)
			{
				x += sign(speedX);
				y += sign(speedY);
				sSpeed -= 1;
			}
			spreadSpeed = 0;
			speedX = 0;
			speedY = 0;
		}
		
		x += speedX;
		y += speedY;
		spreadSpeed = max(spreadSpeed-spreadFrict,0);
	}
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
		if((!player.cDown || forceJump) && (!player.entity_place_collide(0,-11) || ((player.state != State.Crouch || !player.grounded) && player.morphFrame <= 0)))
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