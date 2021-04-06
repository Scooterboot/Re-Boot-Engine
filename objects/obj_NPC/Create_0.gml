/// @description Initialize

image_index = 0;
image_speed = 0;

aiStyle = 0;
mSpeed = 0;
dirX = 1;
dirY = 1;
grav = 0.3;
fGrav = grav;
fallSpeedMax = 4;
velX = 0;
velY = 0;
fVelX = 0;
fVelY = 0;
grounded = false;
collideX = false;
collideY = false;

rotation = 0;

offsetX = 0;
offsetY = 0;

ai[0] = 0;
ai[1] = 0;
ai[2] = 0;
ai[3] = 0;

tileCollide = false;
slopeMovement = false;
fullSpeedOnSlopes = false;

life = 0;
lifeMax = 0;
defenseType = 0;

damage = 0;
knockBack = 5;
knockBackSpeed = 7;
damageImmuneTime = 96;

justHit = false;
dmgFlash = 0;
dead = false;
deathPersistant = false;
deathType = 0;
friendly = false;

dmgMult[0] = 1;
dmgMult[1] = 1;
dmgMult[2] = 1;
dmgMult[3] = 1;
dmgMult[4] = 0;
/*
0 : beams
1 : charge/pseudo screw/missiles/bombs
2 : supers/pbs
3 : speed boost/shine spark/screw attack
4 : grapple beam
*/
freezeImmune = false;

//immuneTime = 0;
//preImmuneTime = 0;

frozenImmuneTime = 0;
frozen = 0;

hurtSound = noone;

freezePlatform = noone;

death1Emit = noone;

setOldPoses = 0;
for(var i = 0; i < 10; i++)
{
	oldPosX[i] = -1;
	oldPosY[i] = -1;
}

function roundedAngle(x1,y1,x2,y2)
{
	return point_direction(scr_round(x1),scr_round(y1),scr_round(x2),scr_round(y2));
}