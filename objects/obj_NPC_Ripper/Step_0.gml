/// @description 
event_inherited();
if(self.PauseAI())
{
	exit;
}

velX = mSpeed*dir;

fVelX = velX;
fVelY = velY;
self.Collision_Normal(fVelX,fVelY,false);