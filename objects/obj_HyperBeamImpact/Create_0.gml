/// @description Initialize
event_inherited();

multiHit = true;
tileCollide = false;

damageType = DmgType.Misc;
damageSubType[1] = false;
damageSubType[2] = false;
damageSubType[3] = false;
damageSubType[4] = true;
damageSubType[5] = false;

array_fill(blockBreakType, true);
array_fill(doorOpenType, true);

particleType = -1;

image_speed = 0;//0.5;

frame = 0;
frameCounter = 0;