/// @description Initialize

event_inherited();

#region Initialize Projectile Types

isCharge = (string_count("ChargeShot",object_get_name(object_index)) > 0);
isIce = (string_count("Ice",object_get_name(object_index)) > 0);
isWave = (string_count("Wave",object_get_name(object_index)) > 0);
isSpazer = (string_count("Spazer",object_get_name(object_index)) > 0);
isPlasma = (string_count("Plasma",object_get_name(object_index)) > 0);
isGrapple = (object_index == obj_GrappleBeamShot);

if(string_count("Beam",object_get_name(object_index)) > 0 && (sprite_index == mask_index || !sprite_exists(mask_index)))
{
	mask_index = mask_BeamShot;
	if(isCharge)
	{
		mask_index = mask_BeamChargeShot;
		if(isSpazer || isPlasma)
		{
			mask_index = mask_BeamChargeShot_Plasma;
		}
	}
}

frame = 0;
frameCounter = 0;

//isBeam = true;
type = ProjType.Beam;

damageType = DmgType.Beam;
if(isCharge)
{
	damageType = DmgType.Charge;
	dmgDelay = 1;
}
damageSubType[1] = true;
damageSubType[2] = isIce;
damageSubType[3] = isWave;
damageSubType[4] = isSpazer;
damageSubType[5] = isPlasma;

if(isIce)
{
    freezeType = 1 + isCharge;
	freezeKill = isCharge;
}

particleType = 0;
if(isIce)
{
	particleType = 1;
}
else if(isPlasma)
{
	particleType = 4;
}
else if(isWave)
{
	particleType = 2;
}
else if(isSpazer)
{
	particleType = 3;
}
else if(isGrapple)
{
	particleType = -1;
}
//emit = noone;
particleDelay = 0;

impactSnd = snd_BeamImpact;

if((isIce || isCharge) && !isSpazer && !isPlasma)
{
	rotation = random(12)*30;
}

if(isWave)
{
	aiStyle = 1;
	amplitude = 8 + (2*isCharge);
	if(isSpazer)
	{
		amplitude = 16;
	}
	wavesPerSecond = 5-(isCharge);
	if(isSpazer)
	{
		wavesPerSecond = 2.5;
	}
	else if(isPlasma)
	{
		wavesPerSecond = 2.75;
	}
	tileCollide = false;
}
else if(isSpazer)
{
	aiStyle = 2;
	amplitude = 12 + isCharge;
	wavesPerSecond = 4;
}
if(isPlasma)
{
	if(isWave || isSpazer)
	{
		delay += 2 + (3*isCharge);
	}
	multiHit = true;
}
else if(isSpazer)
{
	delay += 1 + (1*isCharge);
}
wavesPerSecond *= 1.25;

if(isSpazer || isPlasma)
{
	projLength = sprite_width;
	rotFrame = 1 + (isCharge || isPlasma);
}
//if(!isCharge && !isIce && isWave && !isSpazer && !isPlasma)
if(object_index == obj_PowerBeamShot)
{
	rotFrame = 1;
}


image_speed = 0;//(image_number > 1 && rotFrame == 0);

#endregion