/// @description Initialize
event_inherited();

life = 10;
lifeMax = 10;
damage = 0;//5;

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][1] = 0; // missile
dmgMult[DmgType.Explosive][2] = 1; // super missile
dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 1; // power bomb
dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack

dir = sign(image_xscale);
mSpeed = 1;

gravCounter = 0;
grav = 0.03;//0.07;
fallSpeedMax = 4;

lift = 0.05;//0.11;
liftSpeedMax = 4;

yStart = y;

frame = 0;
frameCounter = 0;
frameSeq = array(0,1,2,1);

deathOffsetX = 0;
deathOffsetY = 8;

function OnXCollision(fVX)
{
	dir = -sign(fVX);
	velX = 0;
	fVelX = 0;
}