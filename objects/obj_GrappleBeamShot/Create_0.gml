event_inherited();

damageType = 3;
damageSubType[1] = true;

particleType = 1;

grappleDist = 0;
grappled = false;
//grappled2 = false;
grapBlock = noone;
grapBlockPosX = -1;//0;
grapBlockPosY = -1;//0;
grapSpeed = 0;
grapSpeedMax = 28;//16;

drawGrapEffect = false;
grapFrame = 0;

direction = 0;
speed = 0;
image_speed = 0.5;

drawGrapDelay = 1;

//timeLeft = 8;

//isGrapple = true;

gp_list = ds_list_create();

function CanDamageNPC(damage,npc)
{
	if(asset_has_any_tag(npc.object_index,"IGrapplePoint",asset_object))
	{
		return false;
	}
	return true;
}