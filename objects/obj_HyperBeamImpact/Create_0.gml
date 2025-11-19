/// @description Initialize
event_inherited();

multiHit = true;
tileCollide = false;

isCharge = true;
damageType = DmgType.Charge;
damageSubType[DmgSubType_Beam.Hyper] = true;

array_fill(blockBreakType, true);
array_fill(doorOpenType, true);

particleType = -1;

image_speed = 0;//0.5;

frame = 0;
frameCounter = 0;