/// @description Code
if(explode <= 0)
{
	TileInteract(x,y);
	
	scr_DamageNPC(x,y,damage,damageType,damageSubType,0,-1,4);
	
	explode++;
}
else
{
	instance_destroy();
}