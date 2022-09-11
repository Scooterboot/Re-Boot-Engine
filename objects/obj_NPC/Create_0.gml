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

rotation = 0;

sprtOffsetX = 0;
sprtOffsetY = 0;

life = 0;
lifeMax = 0;

damage = 0;
knockBack = 10;//5;
knockBackSpeed = 3.5; //7;
damageImmuneTime = 96;

boss = false;

justHit = false;
dmgFlash = 0;
dead = false;
//deathPersistant = false;
deathType = 0;
friendly = false;
immune = false;

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
dmgMult[DmgType.Misc][5] = 0; // unused

dmgAbsorb = false;

realLife = noone;

freezeImmune = false;
frozenImmuneTime = 0;
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

lhc_activate();

function DmgCollide(posX,posY,object,isProjectile)
{
	var npc = id;
	with(object)
	{
		return place_meeting(posX,posY,npc);
	}
	return false;
}
function StrikeNPC(damage, lifeEnd = 0, dethType = -1)
{
	if(instance_exists(realLife))
	{
		realLife.life = max(realLife.life - damage, lifeEnd);
		life = realLife.life;
		lifeMax = realLife.lifeMax;
		
		realLife.dmgFlash = 8;
		realLife.justHit = true;
		
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
	justHit = true;

	if(hurtSound != noone)
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
    if(deathType == 2) // multi-explosion enemy death (e.g. space pirate)
    {
        var d = instance_create_layer(_x,_y,layer_get_id("NPCs"),obj_NPC_DeathAnim);
        d.dethType = 1;
		d.mask_index = mask_index;
    }
    if(deathType == 3) // screw attack/speed booster death
    {
        var d = instance_create_layer(_x,_y,layer_get_id("NPCs"),obj_NPC_DeathAnim);
        d.dethType = 2;
        audio_stop_sound(snd_InstaKillNPC);
        audio_play_sound(snd_InstaKillNPC,0,false);
    }
	
	NPCLoot(_x,_y);
	
    instance_destroy();
}


//
// to do: rewrite this shit
//

dropChance[0] = 75; // base
dropChance[1] = 25; // energy
dropChance[2] = 25; // large energy
dropChance[3] = 20; // missile
dropChance[4] = 15; // super missile
dropChance[5] = 15; // power bomb
function NPCLoot(_x,_y)
{
	if(irandom(100) < dropChance[0])
	{
		var item = noone;
		var rand = irandom(dropChance[1]+dropChance[2]+dropChance[3]+dropChance[4]+dropChance[5])
		if(rand < dropChance[1])
		{
			item = obj_EnergyDrop;
		}
		else if(rand < dropChance[1]+dropChance[2])
		{
			item = obj_LargeEnergyDrop;
		}
		else if(rand < dropChance[1]+dropChance[2]+dropChance[3])
		{
			item = obj_MissileDrop;
		}
		else if(rand < dropChance[1]+dropChance[2]+dropChance[3]+dropChance[4])
		{
			item = obj_SuperMissileDrop;
		}
		else
		{
			item = obj_PowerBombDrop;
		}
		
		instance_create_layer(_x,_y,layer_get_id("Liquids_fg"),item);
	}
}