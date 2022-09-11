/// @description 

if(justHit)
{
	justHit = false;
}
if(dead)
{
    //NPCDeath(x+deathOffsetX,y+deathOffsetY);
	phase = 4;
	instance_destroy(head);
	instance_destroy(rHand);
}