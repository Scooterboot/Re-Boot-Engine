/// @description 
event_inherited();

isWave = true;
isPlasma = true;

multiHit = true;
tileCollide = false;

particleType = -1;

projLength = sprite_width;
rotFrame = 2;
rFrame = 0;

fired = 0;
firedFrame = 0;
firedFrameCounter = 0;

setWave = true;

damageType = DmgType.Misc;
damageSubType[1] = false;
damageSubType[2] = false;
damageSubType[3] = false;
damageSubType[4] = true;
damageSubType[5] = false;

blockDestroyType = 7;
doorOpenType = 4;

impactObj = obj_HyperBeamImpact;
function OnImpact()
{
	if((scr_WithinCamRange() || ignoreCamera) && impactObj != noone)
	{
		var explo = instance_create_layer(x,y,"Projectiles_fg",impactObj);
	    explo.damage = damage;
	}
}