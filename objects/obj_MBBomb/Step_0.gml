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

//scr_DamageNPC(x,y,damage,damageType,0,-1,4);

bombTimer--;
if(bombTimer >= 20)
{
	image_speed = 0.25;
}
else
{
	image_speed = 0.5;
}
if(bombTimer <= 5)
{
	if(instance_exists(obj_Player) && !exploded)
	{
		if(place_meeting(x,y,obj_Player) && (!obj_Player.cDown || forceJump))
		{
			var num = obj_Player.x - x;
			if(abs(num) > 1)
			{
				obj_Player.bombJumpX = obj_Player.velX + (sign(num) * min(abs(num*1.5),2.75));
				if(obj_Player.liquidState > 0)
				{
					obj_Player.bombJumpX /= 3;
				}
			}
			obj_Player.bombJump = obj_Player.bombJumpMax[obj_Player.liquidState];
			with(obj_Player)
			{
				//scr_SpiderEnable(false);
			}
			exploded = true;
		}
	}
	if(bombTimer <= 0)
	{
		instance_destroy();
	}
}