///scr_DamageNPC(x,y,damage,dmgType,freezeType,deathType,immuneTime)
function scr_DamageNPC(posX,posY,_damage,dmgType,dmgSubType,freezeType,deathType,immuneTime)
{
	///@description scr_DamageNPC
	///@param x
	///@param y
	///@param damage
	///@param damageType
	///@param damageSubType
	///@param freezeType
	///@param deathType
	///@param npcImmuneTime
	
	var isProjectile = object_is_ancestor(object_index,obj_Projectile);

	var freezeMax = 500;

	for(var i = 0; i < instance_number(obj_NPC); i++)
	{
	    var npc = instance_find(obj_NPC,i);
		if(!instance_exists(npc) || npc.dead || npc.immune)
		{
			continue;
		}
		if(npc.friendly && isProjectile && !hostile)
		{
			continue;
		}
		if(!npc.DmgCollide(posX,posY,id,isProjectile))
		{
			continue;
		}
		
	    var dmg = _damage;
					
		var dmgMult = 0;
		var arrLength = 5;
		if(dmgType == DmgType.Explosive)
		{
			arrLength = 4;
		}
		for(var d = 1; d < arrLength; d++)
		{
			if(dmgSubType[d])
			{
				dmgMult = max(dmgMult,npc.dmgMult[dmgType][d]);
			}
		}
		dmgMult *= npc.dmgMult[dmgType][0];
		if(dmgType == DmgType.Explosive && dmgSubType[5])
		{
			dmgMult *= npc.dmgMult[dmgType][5];
		}
					
		dmg *= dmgMult;
					
		dmg = npc.ModifyDamageTaken(dmg,id,isProjectile);
                
	    if(dmg > 0)
	    {
	        if(!isProjectile || (npcImmuneTime[i] <= 0))// && impacted <= 0))
	        {
	            var lifeEnd = 0;
	            if(!npc.freezeImmune && ((freezeType == 1 && npc.life <= (dmg*2)) || freezeType == 2))
	            {
	                if(npc.frozen <= 0)
	                {
	                    lifeEnd = 1;
	                    audio_play_sound(snd_FreezeNPC,0,false);
	                }
	                npc.frozen = freezeMax;
	                if(isProjectile)
	                {
	                    part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partFreeze,21*(1+isCharge));
	                }
	            }
	            if(npc.frozenImmuneTime <= 0)
	            {
	                if(!npc.freezeImmune && freezeType > 0 && npc.life <= (dmg*2))
	                {
	                    npc.frozenImmuneTime = immuneTime;
	                }
	                
					npc.StrikeNPC(dmg, lifeEnd, deathType);
								
					npc.OnDamageTaken(dmg,id,isProjectile);
	            }
	            if(isProjectile && particleType != -1)
	            {
	                part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.bTrails[particleType],7*(1+isCharge));
	            }
	        }
	        if(isProjectile && particleType != -1 && multiHit)
	        {
	            part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.bTrails[particleType],(1+isCharge));
	        }
	    }
	    else if(isProjectile)
	    {
	        if(freezeType > 0 && !npc.freezeImmune)
	        {
	            if(npc.frozen <= 0)
	            {
	                audio_play_sound(snd_FreezeNPC,0,false);
	            }
	            npc.frozen = freezeMax;
                        
	            part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partFreeze,21*(1+isCharge));
	        }
			else if(dmgType != DmgType.Explosive || !dmgSubType[5])
	        {
				if(npc.dmgAbsorb)
				{
					npc.OnDamageAbsorbed(_damage,id,isProjectile);
					
					audio_stop_sound(snd_ProjAbsorbed);
					audio_play_sound(snd_ProjAbsorbed,0,false);
				
					part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partAbsorb,1);
					
					if(!multiHit)
					{
						instance_destroy();
					}
				}
				else if(!reflected || multiHit)
				{
		            reflected = true;
					
					audio_stop_sound(snd_Reflect);
		            audio_play_sound(snd_Reflect,0,false);
					
		            part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partDeflect,42);
				}
	        }
                    
	        if(particleType != -1)
	        {
	            var partAmt = 7*(1+isCharge);
	            if(multiHit)
	            {
	                partAmt = (1+isCharge);
	            }
	            part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.bTrails[particleType],partAmt);
	        }
	    }

	    if(isProjectile && (dmg > 0 || !npc.dmgAbsorb))
	    {
	        if(dmg > 0 && npcImmuneTime[i] <= 0)
	        {
	            npcImmuneTime[i] = immuneTime;
	        }
						
	        if(!multiHit)
	        {
	            //instance_destroy();
				impacted = max(impacted,1);
				//damage = 0;
	            //break;
	        }
	    }
	    else if(object_index == obj_Player)
	    {
	        if(isChargeSomersaulting && !isSpeedBoosting && !isScrewAttacking && dmgType == 1 && dmg > 0)
	        {
	            statCharge = 0;
				if(!npc.dead)
				{
					audio_play_sound(snd_InstaKillNPC_Failed,0,false);
				}
	        }
	    }
	}
}
