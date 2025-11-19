/// @description 
event_inherited();

if(self.PauseAI())
{
	exit;
}
else if(!scr_WithinCamRange() && state != 0)
{
	instance_destroy();
	exit;
}

if(state == 0)
{
	velX = 0;
	velY = 0;
	
	player = self.GetPlayer();
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
	velY = -moveSpY;
	
	if(instance_exists(player) && y < player.Center().Y)
	{
		state = 2;
	}
	currentY = y;
}
if(state == 2)
{
	velX = 0;
	velY = 0;
	
	var offY = currentY+heightOffset;
	if(y != offY)
	{
		velY = min(abs(offY-y),moveSpY) * sign(offY-y);
	}
	else if(attackDelay <= 0)
	{
		state = 3;
	}
	attackDelay = max(attackDelay-1,0);
}
if(state == 3)
{
	velX = moveSpX*sign(image_xscale);
	velY = 0;
}

position.X += velX;
position.Y += velY;

x = scr_round(position.X);
y = scr_round(position.Y);