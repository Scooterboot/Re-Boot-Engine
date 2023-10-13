/// @description 
if(global.gamePaused)
{
	exit;
}

frozenImmuneTime = max(frozenImmuneTime-1,0);
frozen = max(frozen - 1, 0);


if(!PauseAI())
{
	fVelX = velX;
	fVelY = velY;

	if(tileCollide)
	{
		Collision_Normal(fVelX,fVelY,16,16,false);
	}
	else
	{
		x += fVelX;
		y += fVelY;
	}
}

platform.isSolid = false;
platform.UpdatePosition(scr_round(bbox_left),scr_round(bbox_top));
platform.isSolid = true;

DamagePlayer();