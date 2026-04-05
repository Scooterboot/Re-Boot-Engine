/// @description Behavior

if(global.GamePaused())
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
	
	self.Collision_Normal(velX,velY,false);
}
else
{
	if(bombTimer <= 40 && dmgScale == 0)
	{
		damage *= 3;
		dmgScale = 1;
	}
	if(bombTimer <= 20 && dmgScale == 1)
	{
		damage *= 2.5;
		dmgScale = 2;
	}
	if(bombTimer <= 1 && dmgScale == 2)
	{
		damage *= 1+(1/3);
		dmgScale = 3;
	}
}