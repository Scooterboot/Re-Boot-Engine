/// @description 

if(!self.PauseAI())
{
	velY += grav;
	
	fVelX = velX;
	fVelY = velY;
	self.Collision_Normal(fVelX,fVelY,false);
	
	if(kill)
	{
		instance_destroy();
	}
}

event_inherited();