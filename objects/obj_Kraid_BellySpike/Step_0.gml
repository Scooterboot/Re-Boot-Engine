/// @description 
if(!self.PauseAI())
{
	if(instance_exists(realLife) && realLife.object_index == obj_Kraid)
	{
		var bodyX = realLife.BodyBone.position.X + realLife.bellySpikePos[posType].X * realLife.dir,
			bodyY = realLife.BodyBone.position.Y + realLife.bellySpikePos[posType].Y;

		if(ai[0] == 0)
		{
			ai[1] = min(ai[1]+1, 24);
	
			position.X = bodyX + ai[1] * dir;
			position.Y = bodyY;
	
			if(ai[1] >= 24)
			{
				ai[0] = 1;
				ai[1] = 0;
			}
		}
		if(ai[0] == 1)
		{
			position.X = bodyX + 24 * dir;
			position.Y = bodyY;
	
			ai[1]++;
			if(ai[1] > 30)
			{
				ai[0] = 2;
				ai[1] = 0;
			
				audio_play_sound(snd_Kraid_SpikeShoot,0,false);
			}
		}
	
		if(realLife.dead)
		{
			instance_destroy();
		}
	}
	else
	{
		ai[0] = 2;
	}

	if(ai[0] == 2)
	{
		velX = moveSpeed * dir;
	}
}

event_inherited();

if(x < -48 || x > room_width+48)
{
	instance_destroy();
}