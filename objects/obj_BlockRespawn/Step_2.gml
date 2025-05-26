/// @description Timer
if(global.gamePaused)
{
    exit;
}

if(initialTime > 0)
{
	if(respawnTime <= 9)
	{
	    visible = true;
	    image_index = (clamp(ceil(respawnTime/3),0,3)-1);
	}
	else
	{
		frameCounter++;
		if(frameCounter > 2)
		{
			image_index++;
			frameCounter = 0;
		}
		if(image_index > 2)
		{
			visible = false;
		}
	}
	
	
	if(respawnTime <= 0)
	{
	    instance_destroy();
	}
	
	if((place_meeting(x,y,obj_Player) || place_meeting(x,y,obj_PushBlock)) && respawnTime <= 30)
	{
	    respawnTime = min(respawnTime + 1, 30);
	}
	else
	{
	    respawnTime = max(respawnTime - 1, 0);
	}
}
else
{
	frameCounter++;
	if(frameCounter > 2)
	{
		image_index++;
		frameCounter = 0;
	}
	if(image_index > 2)
	{
		instance_destroy();
	}
}