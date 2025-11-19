/// @description 
event_inherited();

if(self.PauseAI())
{
	exit;
}

velY += grav;

fVelX = velX;
fVelY = velY;
self.Collision_Normal(fVelX,fVelY,false);

if(kill)
{
	instance_destroy();
}