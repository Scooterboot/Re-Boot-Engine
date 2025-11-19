/// @description 

if(dead && phase != 4)
{
    //NPCDeath(x+deathOffsetX,y+deathOffsetY);
	phase = 4;
	ai[0] = 0;
	ai[1] = 0;
	ai[2] = 0;
	ai[3] = 0;
	instance_destroy(head);
	//instance_destroy(rHand);
	for(var i = 0; i < KraidHitBoxes._Length; i++)
	{
		instance_destroy(dmgBoxes[i]);
		instance_destroy(lifeBoxes[i]);
	}
}