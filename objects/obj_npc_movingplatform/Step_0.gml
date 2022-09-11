/// @description 
if(global.gamePaused)
{
	exit;
}

frozenImmuneTime = max(frozenImmuneTime-1,0);
frozen = max(frozen - 1, 0);


if(PauseAI())
{
	exit;
}

fVelX = velX;
fVelY = velY;//scr_round(velY);

Collision_Normal(fVelX,fVelY,16,16,false);

var top = bbox_top-y;

var oldX = oldPosX[0],
	oldY = oldPosY[0];

platform.x = scr_round(bbox_left);
platform.y = scr_round(bbox_top);

var player = obj_Player;
if (instance_exists(player) && (player.bbox_bottom < bbox_top || player.bbox_bottom < (oldY+top)))
{
	if(place_meeting(x,y-2,player) || place_meeting(oldX,oldY-2,player))
	{
		var moveX = platform.x-oldPlatX,
			moveY = platform.y-oldPlatY;
		with(player)
		{
			Collision_Normal(moveX,moveY,1,1,true);
		}
	}
}

oldPlatX = platform.x;
oldPlatY = platform.y;

//oldX = x;
//oldY = y;