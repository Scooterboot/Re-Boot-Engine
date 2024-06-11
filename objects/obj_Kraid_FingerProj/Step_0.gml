/// @description 
event_inherited();

if(PauseAI())
{
	exit;
}

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,false);

rotation -= 22.5 * sign(image_xscale);

if(_kill)
{
	instance_destroy();
}