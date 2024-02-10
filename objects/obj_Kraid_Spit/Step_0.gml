/// @description 
event_inherited();

if(PauseAI())
{
	exit;
}

velY += grav;

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,false);

if(kill)
{
	instance_destroy();
}