/// @description Initialize
event_inherited();

doorOpenType[DoorOpenType.Missile] = true;
doorOpenType[DoorOpenType.SMissile] = true;
blockBreakType[BlockBreakType.Missile] = true;
blockBreakType[BlockBreakType.SMissile] = true;

damageSubType[2] = true;

exploProj = obj_SuperMissileExplosion;

image_speed = 0;
depth -= 1;

extCamRange = 96;

particleDelay = 4;

function TileInteract(_x,_y)
{
	//BreakBlock(_x,_y,blockBreakType);
	//OpenDoor(_x,_y,doorOpenType);
	//ShutterSwitch(_x,_y,doorOpenType);
}