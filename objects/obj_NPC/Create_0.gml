/// @description Initialize
event_inherited();

npcID = -1;

image_index = 0;
image_speed = 0;

velX = 0;
velY = 0;
fVelX = 0;
fVelY = 0;

grav = 0.3;
fGrav = grav;
fallSpeedMax = 4;

grounded = false;

tileCollide = true;

rotation = 0;

sprtOffsetX = 0;
sprtOffsetY = 0;

life = 0;
lifeMax = 0;

damage = 0;

// damage player through things like speed booster and screw attack
// does not affect i-frames
ignorePlayerImmunity = false;

boss = false;

dmgFlash = 0;
dead = false;
deathType = 0;
hostile = true;
immune = false;

respawning = false;

dmgResist[DmgType.Misc][DmgSubType_Misc.Grapple] = 0;

realLife = noone;

freezeImmune = false;
frozenInvFrames = 0;
frozen = 0;

hurtSound = noone;

createPlatformOnFrozen = true;

setOldPoses = 0;
for(var i = 0; i < 10; i++)
{
	oldPosX[i] = -1;
	oldPosY[i] = -1;
}

function PauseAI()
{
	return (global.GamePaused() || !scr_WithinCamRange() || frozen > 0 || dmgFlash > 0);
}

dmgBoxMask = noone;
dmgBoxOffsetX = 0;
dmgBoxOffsetY = 0;
function DmgBoxRot()
{
	return image_angle;
}

function DamageBoxes()
{
	var _mask = sprite_exists(mask_index) ? mask_index : sprite_index;
	if(dmgBoxMask != noone && sprite_exists(dmgBoxMask))
	{
		_mask = dmgBoxMask;
	}
	
	if(!instance_exists(dmgBoxes[0]))
	{
		dmgBoxes[0] = self.CreateDamageBox(dmgBoxOffsetX,dmgBoxOffsetY,_mask,hostile);
	}
	else
	{
		dmgBoxes[0].offsetX = dmgBoxOffsetX;
		dmgBoxes[0].offsetY = dmgBoxOffsetY;
		dmgBoxes[0].mask_index = _mask;
		dmgBoxes[0].image_xscale = image_xscale;
		dmgBoxes[0].image_yscale = image_yscale;
		dmgBoxes[0].image_angle = self.DmgBoxRot();
		dmgBoxes[0].direction = self.DmgBoxRot();
		dmgBoxes[0].Damage(x+velX,y+velY,damage,damageType,damageSubType);
	}
}

function Entity_CanDealDamage(_selfDmgBox, _lifeBox, _damage, _dmgType, _dmgSubType)
{
	return (damage > 0 && !frozen && !dead);
}

lifeBoxMask = noone;
lifeBoxOffsetX = 0;
lifeBoxOffsetY = 0;
function LifeBoxRot()
{
	return image_angle;
}

function LifeBoxes()
{
	var _mask = sprite_exists(mask_index) ? mask_index : sprite_index;
	if(lifeBoxMask != noone && sprite_exists(lifeBoxMask))
	{
		_mask = lifeBoxMask;
	}
	
	if(!instance_exists(lifeBoxes[0]))
	{
		lifeBoxes[0] = self.CreateLifeBox(lifeBoxOffsetX,lifeBoxOffsetY,_mask,hostile);
	}
	else
	{
		lifeBoxes[0].offsetX = lifeBoxOffsetX;
		lifeBoxes[0].offsetY = lifeBoxOffsetY;
		lifeBoxes[0].mask_index = _mask;
		lifeBoxes[0].image_xscale = image_xscale;
		lifeBoxes[0].image_yscale = image_yscale;
		lifeBoxes[0].image_angle = self.LifeBoxRot();
		lifeBoxes[0].direction = self.LifeBoxRot();
		lifeBoxes[0].UpdatePos(x+velX,y+velY);
	}
}

function Entity_CanTakeDamage(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	return (!immune && !dead);
}

function StrikeNPC(damage, lifeEnd = 0, _deathType = -1)
{
	if(instance_exists(realLife))
	{
		realLife.life = max(realLife.life - damage, lifeEnd);
		life = realLife.life;
		lifeMax = realLife.lifeMax;
		
		realLife.dmgFlash = 8;
		
		if(realLife.life <= 0)
		{
		    if(_deathType >= 0)
		    {
		        realLife.deathType = _deathType;
		    }
		    realLife.dead = true;
		}
		else if(_deathType == 3)
		{
			audio_stop_sound(snd_InstaKillNPC_Failed);
			audio_play_sound(snd_InstaKillNPC_Failed,0,false);
		}
		dead = realLife.dead;
	}
	else
	{
		life = max(life - damage, lifeEnd);
		
		if(life <= 0)
		{
		    if(_deathType >= 0)
		    {
		        deathType = _deathType;
		    }
		    dead = true;
		}
		else if(_deathType == 3)
		{
			audio_stop_sound(snd_InstaKillNPC_Failed);
			audio_play_sound(snd_InstaKillNPC_Failed,0,false);
		}
	}
	
	dmgFlash = 8;

	if(hurtSound != noone)
	{
		audio_stop_sound(hurtSound);
		audio_play_sound(hurtSound,0,false);
	}
}

function OnDamageAbsorbed(_selfLifeBox, _dmgBox, _damage, _dmgType, _dmgSubType) {}

function Entity_OnDamageTaken(_selfLifeBox, _dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _npcDeathType = -1)
{
	var ent = _dmgBox.creator;
	var lifeEnd = 0;
	if(!freezeImmune && ((_freezeType == 1 && life <= (_finalDmg*2)) || _freezeType == 2))
	{
		if(frozen <= 0)
		{
			lifeEnd = 1;
			audio_stop_sound(snd_FreezeNPC);
			audio_play_sound(snd_FreezeNPC,0,false);
		}
		frozen = _freezeTime;
		if(ent.freezeKill)
		{
			lifeEnd = 0;
		}
	}
	if(frozenInvFrames <= 0)
	{
		if(!freezeImmune && _freezeType > 0 && life <= (_finalDmg*2))
		{
			frozenInvFrames = ent.npcInvFrames;
		}
		
		self.StrikeNPC(_finalDmg, lifeEnd, _npcDeathType);
		self.NPC_OnDamageTaken(_selfLifeBox, _dmgBox, _finalDmg, _freezeType, _freezeTime, _npcDeathType)
	}
	
	if(ds_exists(ent.iFrameCounters,ds_type_list))
	{
		if(instance_exists(realLife) && ent.GetInvFrames(realLife) <= 0)
		{
			ds_list_add(ent.iFrameCounters, new InvFrameCounter(realLife, ent.npcInvFrames));
		}
		
		for(var j = 0; j < instance_number(obj_NPC); j++)
		{
			var rlnpc = instance_find(obj_NPC,j);
			if(!instance_exists(rlnpc) || rlnpc == id || rlnpc.dead || rlnpc.immune)
			{
				continue;
			}
		
			if(rlnpc.realLife == id && ent.GetInvFrames(rlnpc) <= 0)
			{
				ds_list_add(ent.iFrameCounters, new InvFrameCounter(rlnpc, ent.npcInvFrames));
			}
		}
	}
}
function Entity_OnDamageTaken_Blocked(_selfLifeBox, _dmgBox, _damage, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600)
{
	if(_freezeType > 0 && !freezeImmune)
	{
	    if(frozen <= 0)
	    {
	        audio_stop_sound(snd_FreezeNPC);
	        audio_play_sound(snd_FreezeNPC,0,false);
	    }
	    frozen = _freezeTime;
	}
	else if(_dmgType != DmgType.ExplSplash)
	{
		if(dmgAbsorb)
		{
			self.OnDamageAbsorbed(_selfLifeBox, _dmgBox, _damage, _dmgType, _dmgSubType);
		}
	}
}
function NPC_OnDamageTaken(_selfLifeBox, _dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _npcDeathType = -1) {}

deathOffsetX = 0;
deathOffsetY = 0;
function NPCDeath(_x,_y)
{
	if(deathType == 0) // default death
    {
        part_particles_create(obj_Particles.partSystemA,_x,_y,obj_Particles.npcDeath[0],1);
        audio_stop_sound(snd_KillNPC);
        audio_play_sound(snd_KillNPC,0,false);
    }
	if(deathType == 1) // large death
    {
        part_particles_create(obj_Particles.partSystemA,_x,_y,obj_Particles.npcDeath[1],1);
        audio_stop_sound(snd_KillNPC);
        audio_play_sound(snd_KillNPC,0,false);
    }
    if(deathType == 2) // multi-explosion enemy death (e.g. space pirate / mini kraid)
    {
        var d = instance_create_layer(_x,_y,layer_get_id("Projectiles_fg"),obj_NPC_DeathAnim);
        d.dethType = 1;
		d.mask_index = mask_index;
    }
    if(deathType == 3) // screw attack/speed booster death
    {
        var d = instance_create_layer(_x,_y,layer_get_id("Projectiles_fg"),obj_NPC_DeathAnim);
        d.dethType = 2;
        audio_stop_sound(snd_InstaKillNPC);
        audio_play_sound(snd_InstaKillNPC,0,false);
    }
	
	self.NPCDropItem(_x,_y);
	
    instance_destroy();
}

spawnerObj = noone;

function NPCDropItem(_x,_y)
{
	var item = self._NPCDropItem(_x,_y);
	if(instance_exists(spawnerObj))
	{
		for(var i = 0; i < array_length(spawnerObj.spawnedNPC); i++)
		{
			if(spawnerObj.spawnedNPC[i] == id)
			{
				spawnerObj.spawnedNPC[i] = item;
				break;
			}
		}
	}
}

enum ItemDropChance
{
	None,
	Energy,
	BigEnergy,
	Missile,
	SuperMissile,
	PowerBomb
}

dropChance[ItemDropChance.None] = 5;
dropChance[ItemDropChance.Energy] = 50;
dropChance[ItemDropChance.BigEnergy] = 50;
dropChance[ItemDropChance.Missile] = 50;
dropChance[ItemDropChance.SuperMissile] = 50;
dropChance[ItemDropChance.PowerBomb] = 50;
// Chances don't need to add up to 100. In fact, they can technically be anything.
// But the total value of them all added together does matter.
// For example, if all values are set 1, 10, or 100, they'd all be a 1/6 chance.
// By default, the total value is 255, which is how SM calculates it (because hex).

function _NPCDropItem(_x,_y)
{
	var player = obj_Player;
	if(instance_exists(player))
	{
		var item = noone;
		
		// "Health Bomb" - always drop health when player is low
		if(player.energy <= player.lowEnergyThresh && (dropChance[ItemDropChance.Energy] > 0 || dropChance[ItemDropChance.BigEnergy] > 0))
		{
			if(dropChance[ItemDropChance.Energy] > 0 && irandom(dropChance[ItemDropChance.Energy]+dropChance[ItemDropChance.BigEnergy]) <= dropChance[ItemDropChance.Energy])
			{
				item = obj_EnergyDrop;
			}
			else
			{
				item = obj_LargeEnergyDrop;
			}
		}
		else // Normal drop behavior
		{
			var dChNum = dropChance[ItemDropChance.None];
			var dChFlag = array_create(6,false);
			dChFlag[0] = true;
			if(player.energy < player.energyMax)
			{
				dChNum += dropChance[ItemDropChance.Energy];
				dChNum += dropChance[ItemDropChance.BigEnergy];
				dChFlag[1] = true;
				dChFlag[2] = true;
			}
			if(player.hasItem[Item.Missile] && player.missileStat < player.missileMax)
			{
				dChNum += dropChance[ItemDropChance.Missile];
				dChFlag[3] = true;
			}
			
			// Super Missiles and Power Bombs are rarer drops, stacking the other chance
			//  values against themselves an additional time.
			if(player.hasItem[Item.SuperMissile] && player.superMissileStat < player.superMissileMax)
			{
				dChNum += dropChance[ItemDropChance.SuperMissile];
				dChFlag[4] = true;
				
				for(var i = 1; i <= 3; i++)
				{
					if(!dChFlag[i])
					{
						dChNum += dropChance[i];
					}
				}
			}
			if(player.hasItem[Item.PowerBomb] && player.powerBombStat < player.powerBombMax)
			{
				dChNum += dropChance[ItemDropChance.PowerBomb];
				dChFlag[5] = true;
				
				for(var i = 1; i <= 3; i++)
				{
					if(!dChFlag[i])
					{
						dChNum += dropChance[i];
					}
				}
			}
			
			var items = array_create(0);
			items[0] = noone;
			items[1] = obj_EnergyDrop;
			items[2] = obj_LargeEnergyDrop;
			items[3] = obj_MissileDrop;
			items[4] = obj_SuperMissileDrop;
			items[5] = obj_PowerBombDrop;
			
			if(dChNum > dropChance[ItemDropChance.None])
			{
				var dChRand = irandom(dChNum-1)+1;
				var dChNum2 = 0;
				for(var i = 0; i < array_length(dropChance); i++)
				{
					if(dChFlag[i] && dChRand > dChNum2)
					{
						dChNum2 += dropChance[i];
						if(dChRand <= dChNum2)
						{
							item = items[i];
							break;
						}
					}
				}
			}
		}
		
		if(item != noone)
		{
			return instance_create_layer(_x,_y,layer_get_id("Liquids_fg"),item);
		}
	}
	return noone;
}

solids = array_concat(ColType_Solid,ColType_MovingSolid,ColType_NPCSolid);

function OnXCollision(fVX, isOOB = false)
{
	if(sign(velX) == sign(fVelX))
	{
		velX = 0;
	}
	fVelX = 0;
}
function OnYCollision(fVY, isOOB = false)
{
	if(sign(velY) == sign(fVelY))
	{
		velY = 0;
	}
	fVelY = 0;
}