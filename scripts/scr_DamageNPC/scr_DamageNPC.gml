///scr_DamageNPC(x,y,damage,dmgType,freezeType,deathType,immuneTime)
function scr_DamageNPC(posX,posY,dmg,dmgType,dmgSubType,freezeType,deathType,immuneTime)
{
	var xx = posX,
		yy = posY,
		freeze = freezeType,
		dType = deathType,
		immune = immuneTime;

	var freezeMax = 500;

	if(place_meeting(xx,yy,obj_NPC))
	{
	    for(var i = 0; i < instance_number(obj_NPC); i++)
	    {
	        var npc = instance_find(obj_NPC,i);
	        if (instance_exists(npc) && !npc.dead && !npc.friendly)
	        {
	            if(place_meeting(xx,yy,npc))
	            {
	                //dmg *= npc.dmgMult[dmgType];
					var dmgMult = 0;
					var arrLength = min(array_length(npc.dmgMult[dmgType]),array_length(dmgSubType));
					for(var d = 0; d < arrLength; d++)
					{
						if(dmgSubType[d])
						{
							dmgMult += npc.dmgMult[dmgType][d];
						}
					}
					dmg *= dmgMult;
                
	                if(dmg > 0)
	                {
	                    if(!object_is_ancestor(object_index,obj_Projectile) || (npcImmuneTime[i] <= 0 && impacted <= 0))
	                    {
	                        var lifeEnd = 0;
	                        if(!npc.freezeImmune && ((freeze == 1 && npc.life <= (dmg*2)) || freeze == 2))
	                        {
	                            if(npc.frozen <= 0)
	                            {
	                                lifeEnd = 1;
	                                audio_play_sound(snd_FreezeNPC,0,false);
	                            }
	                            npc.frozen = freezeMax;
	                            if(object_is_ancestor(object_index,obj_Projectile))
	                            {
	                                part_particles_create(obj_Particles.partSystemA,xx,yy,obj_Particles.partFreeze,21*(1+isCharge));
	                            }
	                        }
	                        if(npc.frozenImmuneTime <= 0)
	                        {
	                            if(!npc.freezeImmune && freeze > 0 && npc.life <= (dmg*2))
	                            {
	                                npc.frozenImmuneTime = immune;
	                            }
	                            npc.life = max(npc.life - dmg,lifeEnd);
	                            if(npc.dmgFlash <= 0)
	                            {
	                                npc.dmgFlash = 4;
	                            }
	                            npc.justHit = true;
        
	                            if(npc.hurtSound != noone)
	                            {
	                                audio_play_sound(npc.hurtSound,0,false);
	                            }
								
								npc.OnDamageTaken(dmg);
        
	                            if(npc.life <= 0)
	                            {
	                                if(dType >= 0)
	                                {
	                                    npc.deathType = dType;
	                                }
	                                npc.dead = true;
	                            }
	                        }
	                        if(object_is_ancestor(object_index,obj_Projectile) && particleType != -1)
	                        {
	                            //part_particles_create(obj_Particles.partSystemA,xx,yy,obj_Particles.PartBeam[particleType*2+1],7*(1+isCharge));
	                            part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.bTrails[particleType],7*(1+isCharge));
	                        }
	                    }
	                    if(object_is_ancestor(object_index,obj_Projectile) && particleType != -1 && multiHit)
	                    {
	                        //part_particles_create(obj_Particles.partSystemA,xx,yy,obj_Particles.PartBeam[particleType*2+1],(1+isCharge));
	                        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.bTrails[particleType],(1+isCharge));
	                    }
	                }
	                else if(object_is_ancestor(object_index,obj_Projectile))
	                {
	                    if(freeze > 0 && !npc.freezeImmune)
	                    {
	                        if(npc.frozen <= 0)
	                        {
	                            audio_play_sound(snd_FreezeNPC,0,false);
	                        }
	                        npc.frozen = freezeMax;
                        
	                        part_particles_create(obj_Particles.partSystemA,xx,yy,obj_Particles.partFreeze,21*(1+isCharge));
	                    }
	                    else
	                    {
	                        reflected = true;
	                        //if(!audio_is_playing(snd_Reflect))
	                        //{
	                            audio_stop_sound(snd_Reflect);
	                            audio_play_sound(snd_Reflect,0,false);
	                        //}
	                        part_particles_create(obj_Particles.partSystemA,xx,yy,obj_Particles.partDeflect,42);
	                    }
                    
	                    if(particleType != -1)
	                    {
	                        var partAmt = 7*(1+isCharge);
	                        if(multiHit)
	                        {
	                            partAmt = (1+isCharge);
	                        }
	                        //part_particles_create(obj_Particles.partSystemA,xx,yy,obj_Particles.PartBeam[particleType*2+1],partAmt);
	                        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.bTrails[particleType],partAmt);
	                    }
	                }

	                if(object_is_ancestor(object_index,obj_Projectile))
	                {
	                    if(!multiHit)
	                    {
	                        //instance_destroy();
							impacted = max(impacted,1);
							//damage = 0;
	                        break;
	                    }
	                    else if(dmg > 0 && npcImmuneTime[i] <= 0)
	                    {
	                        npcImmuneTime[i] = immune;
	                    }
	                }
	                else if(object_index == obj_Player)
	                {
	                    if(isChargeSomersaulting && !isSpeedBoosting && !isScrewAttacking && dmgType == 1 && dmg > 0)
	                    {
	                        statCharge = 0;
	                    }
	                }
	            }
	        }
	    }
	}
}
