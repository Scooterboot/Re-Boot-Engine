/// @description Initialize
event_inherited();

doorOpenType = 2;

damageSubType[1] = true;
damageSubType[2] = true;

exploProj = obj_SuperMissileExplosion;

image_speed = 0;
depth -= 1;

particleDelay = 4;

function TileInteract(_x,_y)
{
	//BreakBlock(_x,_y,blockDestroyType);
	//OpenDoor(_x,_y,doorOpenType);
	//ShutterSwitch(_x,_y,doorOpenType);
}