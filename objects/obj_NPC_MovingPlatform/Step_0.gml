/// @description 
event_inherited();
if(global.gamePaused)
{
	exit;
}

if(!PauseAI())
{
	fVelX = velX;
	fVelY = velY;

	if(tileCollide)
	{
		Collision_Normal(fVelX,fVelY,false);
	}
	else
	{
		x += fVelX;
		y += fVelY;
	}
}

self.UpdateMovingTiles();