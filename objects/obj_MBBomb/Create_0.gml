/// @description Initialize
event_inherited();

image_speed = 0.25;
bombTimer = 55;//60;
//exploded = false;
ignoreCamera = true;

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

doorOpenType = 5;

function OnXCollision(fVX)
{
	if(spreadType < 2)
	{
		velX *= -0.5;
	}
	else
	{
		velX = 0;
	}
	ImpactBreak();
}
function OnYCollision(fVY)
{
	if(spreadType < 2)
	{
		velY *= -0.5;
	}
	else
	{
		velY = 0;
	}
	ImpactBreak();
}
function ImpactBreak()
{
	var arr = [obj_ShotBlock,obj_BombBlock];
	if(impacted <= 0 && collision_rectangle(bb_left()-2,bb_top()-2,bb_right()+2,bb_bottom()+2,arr,false,true))
	{
		impacted = 1;
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