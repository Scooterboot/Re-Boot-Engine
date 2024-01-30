/// @description Initialize
event_inherited();

doorOpenType = 1;

damageSubType[1] = true;

exploProj = obj_MissileExplosion;

image_speed = 0;
depth -= 1;

particleDelay = 1;

function TileInteract(_x,_y)
{
	//BreakBlock(_x,_y,blockDestroyType);
	//OpenDoor(_x,_y,doorOpenType);
	//ShutterSwitch(_x,_y,doorOpenType);
}