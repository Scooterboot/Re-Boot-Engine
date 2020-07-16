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

npcImmuneTime[instance_number(obj_NPC)] = 0;


knockBack = 5;
knockBackSpeed = 7;
damageImmuneTime = 96;

isBomb = false;
isMissile = false;
isSuperMissile = false;
isBeam = false;
isGrapple = false;

isCharge = false;
isIce = false;
isWave = false;
isSpazer = false;
isPlasma = false;

#endregion