/// @description Initialize
event_inherited();

life = 10;
lifeMax = 10;
damage = 5;

dmgMult[DmgType.Beam][0] = 0;
dmgMult[DmgType.Charge][0] = 0;
dmgMult[DmgType.Explosive][0] = 0;
dmgMult[DmgType.Explosive][2] = 1;
dmgMult[DmgType.Explosive][4] = 1;

mSpeed2 = 1;
mSpeed = mSpeed2;

dirFrame = 5*dir;
frame = 0;
frameCounter = 0;
frameSeq = array(0,1,2,1);