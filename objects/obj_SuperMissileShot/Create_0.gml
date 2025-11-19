/// @description Initialize
event_inherited();

doorOpenType[DoorOpenType.Missile] = true;
doorOpenType[DoorOpenType.SMissile] = true;
blockBreakType[BlockBreakType.Missile] = true;
blockBreakType[BlockBreakType.SMissile] = true;

damageSubType[DmgSubType_Explosive.SuperMissile] = true;

exploProj = obj_SuperMissileExplosion;

image_speed = 0;
depth -= 1;

extCamRange = 96;

particleDelay = 4;

function TileInteract(_x,_y) {}