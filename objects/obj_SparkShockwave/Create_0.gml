/// @description Initialize
event_inherited();

damageType = DmgType.Misc;
damageSubType = array_create(DmgSubType_Misc._Length, false);
damageSubType[DmgSubType_Misc.All] = true;
damageSubType[DmgSubType_Misc.SpeedBoost] = true;

freezeType = 0;

dmgDelay = 0;

tileCollide = false;
multiHit = true;

npcDeathType = 3;

particleType = -1;

rotFrame = 4;

array_fill(doorOpenType,false);
array_fill(blockBreakType,false);