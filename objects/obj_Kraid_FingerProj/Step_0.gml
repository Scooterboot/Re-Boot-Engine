/// @description 

if(!self.PauseAI())
{
	rotation -= 22.5 * sign(image_xscale);
	
	fVelX = velX;
	fVelY = velY;
	self.Collision_Normal(fVelX,fVelY,false);
	
	if(_kill)
	{
		instance_destroy();
	}
}

event_inherited();