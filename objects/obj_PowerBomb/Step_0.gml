/// @description Behavior

if(global.gamePaused)
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
if(bombTimer <= 0)
{
	if(instance_exists(obj_Player))
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
		}
	}
	audio_play_sound(snd_PowerBombExplode,0,false);
	var bomb = instance_create_layer(x,y+11,"Projectiles_fg",obj_PowerBombExplosion);
	bomb.damage = damage;
	bomb.damageType = damageType;
	instance_destroy();
}