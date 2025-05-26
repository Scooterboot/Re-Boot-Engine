/// @description 

//scr_OpenDoor(x,y,1);
//scr_BreakBlock(x,y,2);
TileInteract(x,y);

scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,10);

frameCounter++;
if(frameCounter > 1)
{
	frame++;
	frameCounter = 0;
}
image_index = frame;
if(image_index >= image_number)
{
	instance_destroy();
}