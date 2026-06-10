/// @description Timer
if(global.GamePaused())
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
	
	var placeCheck = self.checkEntity(x,y);
	if(blockIndex == obj_CrumbleBlock)
	{
		placeCheck |= place_meeting(x,y-2,[obj_Player,obj_PushBlock]);
	}
	if(placeCheck && respawnTime <= 30)
	{
	    respawnTime = min(respawnTime + 1, 30);
	}
	else
	{
		if(respawnTime <= 0)
		{
		    instance_destroy();
		}
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
