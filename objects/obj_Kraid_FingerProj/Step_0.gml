/// @description 
event_inherited();

if(PauseAI())
{
	exit;
}

fVelX = velX;
fVelY = velY;
Collision_Normal(fVelX,fVelY,16,16,false);

rotation -= 22.5 * sign(image_xscale);