/// @description 
event_inherited();

if(!scr_WithinCamRange() && state != 0)
{
	instance_destroy();
	exit;
}
if(PauseAI())
{
	exit;
}

if(state == 0)
{
	velX = 0;
	velY = 0;
	
	player = GetPlayer();
	if(instance_exists(player))
	{
		image_xscale = 1;
		if(player.x < x)
		{
			image_xscale = -1;
		}
		
		if(detectDelay <= 0)
		{
			state = 1;
		}
		else
		{
			detectDelay--;
		}
	}
}
if(state == 1)
{
	velX = 0;
	velY = -1;
	
	if(instance_exists(player) && y < player.Center().Y)
	{
		state = 2;
	}
}
if(state == 2)
{
	velX = 2*sign(image_xscale);
	velY = 0;
}

x += velX;
y += velY;