/// @description 


if(justHit)
{
	eyeState = 0;
	eyeTimer = 0;
	eyeChance++;
	justHit = false;
}

if(dead)
{
    //NPCDeath(x+deathOffsetX,y+deathOffsetY);
	deathTimer++;
	if(deathTimer > 30)
	{
		NPCDeath(x+deathOffsetX,y+deathOffsetY);
		part_particles_create(obj_Particles.partSystemA,x+deathOffsetX,y+deathOffsetY,obj_Particles.npcDeath[1],1);
        audio_stop_sound(snd_KillNPC);
        audio_play_sound(snd_KillNPC,0,false);
	}
}