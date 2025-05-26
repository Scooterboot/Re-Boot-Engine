/// @description Initialize
event_inherited();

damageType = DmgType.Misc;
damageSubType[0] = true;
damageSubType[1] = false;
damageSubType[2] = true;
damageSubType[3] = false;
damageSubType[4] = false;
damageSubType[5] = false;

freezeType = 0;

dmgDelay = 0;

tileCollide = false;
multiHit = true;

npcDeathType = 3;

particleType = -1;

rotFrame = 4;

array_fill(doorOpenType,false);
array_fill(blockBreakType,false);