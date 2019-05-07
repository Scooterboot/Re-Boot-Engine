/// @description Initialize

#region Initialize Base Variables
image_speed = 0;
aiStyle = 0;
hostile = false;
tileCollide = true;
multiHit = false;
damage = 0;
damageType = 0;
particleType = -1;
impactSnd = snd_BeamImpact;

impact = 0;
reflected = false;

shift = 0;
t = 0;
increment = pi*2 / 60;
xx = xstart;
yy = ystart;
dir = 1;

waveDir = 1;

amplitude = 0;
wavesPerSecond = 0;
delay = 0;

speed = 0;
velocity = 0;
direction = 0;
image_angle = direction;
speed_x = 0;
speed_y = 0;

particleDelay = 0;
rot = direction;
for(var i = 0; i < 11; i++)
{
	oldPosX[i] = x;
	oldPosY[i] = y;
}
for(var i = 0; i < 11; i++)
{
	oldRot[i] = image_angle;
}
oldPositionsSet = false;

emit = noone;

water_init(0);

creator = noone;

//npcImmuneTime[instance_number(obj_NPC)] = 0;


knockBack = 5;
knockBackSpeed = 7;
damageImmuneTime = 96;
#endregion
#region Initialize Projectile Types
image_speed = (image_number > 1);

isCharge = (string_count("ChargeShot",object_get_name(object_index)) > 0);
isIce = (string_count("Ice",object_get_name(object_index)) > 0);
isWave = (string_count("Wave",object_get_name(object_index)) > 0);
isSpazer = (string_count("Spazer",object_get_name(object_index)) > 0);
isPlasma = (string_count("Plasma",object_get_name(object_index)) > 0);

isBomb = (string_count("Bomb",object_get_name(object_index)) > 0);
isMissile = (string_count("Missile",object_get_name(object_index)) > 0);
isSuperMissile = (string_count("SuperMissile",object_get_name(object_index)) > 0);
isBeam = (string_count("Beam",object_get_name(object_index)) > 0);

isGrapple = (string_count("Grapple",object_get_name(object_index)) > 0);

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
		delay += 3 + (3*isCharge);
	}
	multiHit = true;
}
else if(isSpazer)
{
	delay += 1 + (2*isCharge);
}

if(isCharge || isMissile)
{
	damageType = 1;
}
if(isSuperMissile)
{
	damageType = 2;
}
#endregion