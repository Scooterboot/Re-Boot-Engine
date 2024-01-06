/// @description Initialize
event_inherited();

image_speed = 0.25;
bombTimer = 55;//60;
//exploded = false;

velX = 0;
velY = 0;
spreadType = -1;
spreadSpeed = 0;
spreadDir = 0;
spreadFrict = 4;

type = ProjType.Bomb;

damageSubType[3] = true;

exploProj = obj_MBBombExplosion;
exploDmgMult = 1;

function OnXCollision(fVX)
{
	if(spreadType < 2)
	{
		velX *= -0.5;
	}
}
function OnYCollision(fVY)
{
	if(spreadType < 2)
	{
		velY *= -0.5;
	}
}
function OnBottomCollision(fVY)
{
	if(spreadType == 0)
	{
		var frict = 0.2;
		if(velX > 0)
		{
			velX = max(velX-frict,0);
		}
		if(velX < 0)
		{
			velX = min(velX+frict,0);
		}
	}
}