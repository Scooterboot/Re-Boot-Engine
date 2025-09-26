/// @description 
event_inherited();
if(global.GamePaused())
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
		position.X += fVelX;
		position.Y += fVelY;
		x = scr_round(position.X);
		y = scr_round(position.Y);
	}
}

self.UpdateMovingTiles();