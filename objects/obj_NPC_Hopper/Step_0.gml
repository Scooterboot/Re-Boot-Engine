/// @description Behavior
event_inherited();
if(self.PauseAI())
{
	exit;
}

var player = obj_Player;
if(instance_exists(player))
{
	if(sign(player.x-x) != 0)
	{
		jumpXDir = sign(player.x-x);
	}
}

if(grounded)
{
	velX = 0;
	jumpCounter++;
	
	if(jumpCounter > jumpCounterMax)
	{
		var j = 0;
		if(irandom(1) == 0)
		{
			j = 1;
		}
		velX = jumpSpeedX[j]*jumpXDir;
		velY = -jumpSpeedY[j]*gravDir;
		
		grounded = false;
		jumpCounter = 0;
	}
}

if(gravDir == 1)
{
	velY = min(velY+fGrav,fallSpeedMax);
}
if(gravDir == -1)
{
	velY = max(velY-fGrav,-fallSpeedMax);
}

self.Collision_Normal(velX,velY,true);

if(!self.entity_place_collide(0,2*gravDir))
{
	grounded = false;
}