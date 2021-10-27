/// @description Initialize

event_inherited();

#region Initialize Projectile Types
image_speed = (image_number > 1);

isCharge = (string_count("ChargeShot",object_get_name(object_index)) > 0);
isIce = (string_count("Ice",object_get_name(object_index)) > 0);
isWave = (string_count("Wave",object_get_name(object_index)) > 0);
isSpazer = (string_count("Spazer",object_get_name(object_index)) > 0);
isPlasma = (string_count("Plasma",object_get_name(object_index)) > 0);

isBeam = true;

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
else if(isMissile || isGrapple)
{
	particleType = -1;
}

if((isIce || isCharge) && !isSpazer && !isPlasma)
{
	rot = random(12)*30;
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

if(isCharge || isMissile)
{
	damageType = 1;
}
if(isSuperMissile)
{
	damageType = 2;
}
#endregion