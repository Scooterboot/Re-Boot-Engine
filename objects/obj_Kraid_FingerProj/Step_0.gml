/// @description 
event_inherited();

if(self.PauseAI())
{
	exit;
}

fVelX = velX;
fVelY = velY;
self.Collision_Normal(fVelX,fVelY,false);

rotation -= 22.5 * sign(image_xscale);

if(_kill)
{
	instance_destroy();
}