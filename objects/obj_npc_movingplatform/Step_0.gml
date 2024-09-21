/// @description 
if(global.gamePaused)
{
	exit;
}

frozenInvFrames = max(frozenInvFrames-1,0);
frozen = max(frozen - 1, 0);


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

platform.isSolid = false;
platform.UpdatePosition(scr_round(bb_left()),scr_round(bb_top()));
platform.isSolid = true;

DamagePlayer();