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
	mask_index = sprt_MBBombExplosion;
	var player = collision_circle(x,y,(bbox_right-bbox_left)/3,obj_Player,false,true);
	if(instance_exists(player))
	{
		if(!player.cDown || forceJump)
		{
			var num = player.x - x;
			if(abs(num) > 2)
			{
				player.bombJumpX = player.velX + (sign(num) * min(abs(num*1.5),2.75));
				if(player.liquidState > 0)
				{
					player.bombJumpX /= 3;
				}
			}
			player.bombJump = player.bombJumpMax[player.liquidState];
			//player.SpiderEnable(false);
		}
	}
	audio_play_sound(snd_PowerBombExplode,0,false);
	var bomb = instance_create_layer(x,y+11,"Projectiles_fg",obj_PowerBombExplosion);
	bomb.damage = damage;
	bomb.damageType = damageType;
	instance_destroy();
}