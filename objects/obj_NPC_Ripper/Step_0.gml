/// @description 

if(!self.PauseAI())
{
	velX = mSpeed*dir;
	
	fVelX = velX;
	fVelY = velY;
	self.Collision_Normal(fVelX,fVelY,false);
}
event_inherited();