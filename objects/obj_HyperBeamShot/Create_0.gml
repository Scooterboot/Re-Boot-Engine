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
function OnImpact(posX,posY)
{
	if((scr_WithinCamRange() || ignoreCamera) && impactObj != noone)
	{
		var explo = instance_create_layer(posX,posY,"Projectiles_fg",impactObj);
	    explo.damage = damage;
		
		if(impactObj == obj_HyperBeamImpact)
		{
			var dist = instance_create_depth(0,0,0,obj_Distort);
			dist.left = x-18;
			dist.right = x+18;
			dist.top = y-18;
			dist.bottom = y+18;
			dist.alpha = 0;
			dist.alphaNum = 1;
			dist.alphaRate = 0.25;
			dist.alphaMult = 0.5;
			dist.spread = 0.625;
		}
	}
}