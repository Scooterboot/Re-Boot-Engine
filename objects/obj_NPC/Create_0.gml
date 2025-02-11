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
knockBack = 5;//9;
knockBackSpeed = 5;
damageInvFrames = 96;

// damage player through things like speed booster and screw attack
// does not affect i-frames
ignorePlayerImmunity = false;

boss = false;

dmgFlash = 0;
dead = false;
//deathPersistant = false;
deathType = 0;
friendly = false;
immune = false;

respawning = false;

enum DmgType
{
	Beam = 0,
	Charge = 1,
	Explosive = 2,
	Misc = 3
};

// beams
dmgMult[DmgType.Beam][0] = 1; // all
dmgMult[DmgType.Beam][1] = 1; // power beam
dmgMult[DmgType.Beam][2] = 1; // ice beam
dmgMult[DmgType.Beam][3] = 1; // wave beam
dmgMult[DmgType.Beam][4] = 1; // spazer
dmgMult[DmgType.Beam][5] = 1; // plasma beam

// charge shot / psuedo screw attack
dmgMult[DmgType.Charge][0] = 1; // all
dmgMult[DmgType.Charge][1] = 1; // power beam
dmgMult[DmgType.Charge][2] = 1; // ice beam
dmgMult[DmgType.Charge][3] = 1; // wave beam
dmgMult[DmgType.Charge][4] = 1; // spazer
dmgMult[DmgType.Charge][5] = 1; // plasma beam

// explosives
dmgMult[DmgType.Explosive][0] = 1; // all
dmgMult[DmgType.Explosive][1] = 1; // missile
dmgMult[DmgType.Explosive][2] = 1; // super missile
dmgMult[DmgType.Explosive][3] = 1; // bomb
dmgMult[DmgType.Explosive][4] = 1; // power bomb
dmgMult[DmgType.Explosive][5] = 1; // splash damage

// misc
dmgMult[DmgType.Misc][0] = 1; // all
dmgMult[DmgType.Misc][1] = 0; // grapple beam
dmgMult[DmgType.Misc][2] = 1; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 1; // screw attack
dmgMult[DmgType.Misc][4] = 1; // hyper beam
dmgMult[DmgType.Misc][5] = 1; // boost ball

dmgAbsorb = false;

realLife = noone;

freezeImmune = false;
frozenInvFrames = 0;
frozen = 0;

hurtSound = noone;

freezePlatform = noone;


setOldPoses = 0;
for(var i = 0; i < 10; i++)
{
	oldPosX[i] = -1;
	oldPosY[i] = -1;
}

function PauseAI()
{
	return (global.gamePaused || !scr_WithinCamRange() || frozen > 0 || dmgFlash > 0);
}

/*function roundedAngle(x1,y1,x2,y2)
{
	return point_direction(scr_round(x1),scr_round(y1),scr_round(x2),scr_round(y2));
}*/

function DmgColPlayer()
{
	return instance_place(x,y,obj_Player);
}
function DamagePlayer()
{
	if(!friendly && damage > 0 && !frozen && !dead)
	{
	    var player = DmgColPlayer();
	    if(instance_exists(player))
	    {
	        var ang = 45;
			if(player.bb_bottom() > bb_bottom())
			{
				ang = 315;
			}
			if(player.x < x)
			{
				ang = 135;
				if(player.bb_bottom() > bb_bottom())
				{
					ang = 225;
				}
			}
			var knockX = lengthdir_x(knockBackSpeed,ang),
				knockY = lengthdir_y(knockBackSpeed,ang);
			player.StrikePlayer(damage,knockBack,knockX,knockY,damageInvFrames,ignorePlayerImmunity);
			
			OnDamagePlayer();
	    }
	}
}
function OnDamagePlayer() {}

function DmgCollide(posX,posY,object,isProjectile)
{
	if(!instance_exists(object)) { return false; }
	
	var offX = object.x-posX,
		offY = object.y-posY;
	return place_meeting(x+offX,y+offY,object);
}
function StrikeNPC(damage, dmgType, dmgSubType, lifeEnd = 0, dethType = -1)
{
	if(instance_exists(realLife))
	{
		realLife.life = max(realLife.life - damage, lifeEnd);
		life = realLife.life;
		lifeMax = realLife.lifeMax;
		
		realLife.dmgFlash = 8;
		
		if(realLife.life <= 0)
		{
		    if(dethType >= 0)
		    {
		        realLife.deathType = dethType;
		    }
		    realLife.dead = true;
		}
		dead = realLife.dead;
	}
	else
	{
		life = max(life - damage, lifeEnd);
		
		if(life <= 0)
		{
		    if(dethType >= 0)
		    {
		        deathType = dethType;
		    }
		    dead = true;
		}
	}
	
	dmgFlash = 8;

	if(hurtSound != noone && (dmgType != DmgType.Explosive || !dmgSubType[4]))
	{
		audio_stop_sound(hurtSound);
		audio_play_sound(hurtSound,0,false);
	}
}

function ModifyDamageTaken(damage,object,isProjectile)
{
	return damage;
}
function OnDamageTaken(damage, object, isProjectile)
{
	
}
function OnDamageAbsorbed(damage, object, isProjectile)
{
	
}

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
	
	NPCDropItem(_x,_y);
	
    instance_destroy();
}

spawnerObj = noone;

function NPCDropItem(_x,_y)
{
	var item = _NPCDropItem(_x,_y);
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
dropChance[0] = 5; // nothing
dropChance[1] = 50; // energy
dropChance[2] = 50; // large energy
dropChance[3] = 50; // missile
dropChance[4] = 50; // super missile
dropChance[5] = 50; // power bomb
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
		if(player.energy <= player.lowEnergyThresh && (dropChance[1] > 0 || dropChance[2] > 0))
		{
			if(dropChance[1] > 0 && irandom(dropChance[1]+dropChance[2]) <= dropChance[1])
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
			var dChNum = dropChance[0];
			var dChFlag = array_create(6,false);
			dChFlag[0] = true;
			if(player.energy < player.energyMax)
			{
				dChNum += dropChance[1];
				dChNum += dropChance[2];
				dChFlag[1] = true;
				dChFlag[2] = true;
			}
			if(player.hasItem[Item.Missile] && player.missileStat < player.missileMax)
			{
				dChNum += dropChance[3];
				dChFlag[3] = true;
			}
			if(player.hasItem[Item.SMissile] && player.superMissileStat < player.superMissileMax)
			{
				dChNum += dropChance[4];
				dChFlag[4] = true;
				
				for(var i = 1; i <= 3; i++)
				{
					if(!dChFlag[i])
					{
						dChNum += dropChance[i];
					}
				}
			}
			if(player.hasItem[Item.PBomb] && player.powerBombStat < player.powerBombMax)
			{
				dChNum += dropChance[5];
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
			
			if(dChNum > dropChance[0])
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

function OnXCollision(fVX)
{
	if(sign(velX) == sign(fVelX))
	{
		velX = 0;
	}
	fVelX = 0;
}
function OnYCollision(fVY)
{
	if(sign(velY) == sign(fVelY))
	{
		velY = 0;
	}
	fVelY = 0;
}