/// @description 

if(!self.PauseAI())
{
	fVelX = velX;
	fVelY = velY;

	if(tileCollide)
	{
		self.Collision_Normal(fVelX,fVelY,false);
	}
	else
	{
		position.X += fVelX;
		position.Y += fVelY;
		x = scr_round(position.X);
		y = scr_round(position.Y);
	}
}

if(!global.GamePaused())
{
	self.UpdateMovingTiles();
}

event_inherited();