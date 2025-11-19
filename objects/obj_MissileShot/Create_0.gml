/// @description Initialize
event_inherited();

doorOpenType[DoorOpenType.Missile] = true;
blockBreakType[BlockBreakType.Missile] = true;

damageSubType[DmgSubType_Explosive.Missile] = true;

exploProj = obj_MissileExplosion;

image_speed = 0;
depth -= 1;

particleDelay = 1;

function TileInteract(_x,_y) {}