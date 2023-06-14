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
damageImmuneTime = 96;

// damage player through things like speed booster and screw attack
// does not affect i-frames
ignorePlayerImmunity = false;

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
	        if (player.immuneTime <= 0 && (!player.immune || ignorePlayerImmunity))//!player.isChargeSomersaulting && !player.isScrewAttacking && !player.isSpeedBoosting)
	        {
	            //var ang = point_direction(x,y,obj_Samus.x,obj_Samus.y);
	            var ang = 45;
	            if(player.bbox_bottom > bbox_bottom)
	            {
	                ang = 315;
	            }
	            if(player.x < x)
	            {
	                ang = 135;
	                if(player.bbox_bottom > bbox_bottom)
	                {
	                    ang = 225;
	                }
	            }
	            var knockX = lengthdir_x(knockBackSpeed,ang),
	                knockY = lengthdir_y(knockBackSpeed,ang);
	            scr_DamagePlayer(damage,knockBack,knockX,knockY,damageImmuneTime);
	        }
	    }
	}
}

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

#region Base Collision Checks

block_list = ds_list_create();

function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	//return entity_place_meeting(xx+offsetX,yy+offsetY,"ISolid") || entity_place_meeting(xx+offsetX,yy+offsetY,"INPCSolid");
	if(lhc_place_meeting(xx+offsetX,yy+offsetY,"ISolid") || lhc_place_meeting(xx+offsetX,yy+offsetY,"INPCSolid"))
	{
		var num = instance_place_list(xx+offsetX,yy+offsetY,all,block_list,true);
		for(var i = 0; i < num; i++)
		{
			if(instance_exists(block_list[| i]) && (asset_has_any_tag(block_list[| i].object_index,"ISolid",asset_object) || asset_has_any_tag(block_list[| i].object_index,"INPCSolid",asset_object)) && !asset_has_any_tag(block_list[| i].object_index,"IMovingSolid",asset_object))
			{
				ds_list_clear(block_list);
				return true;
			}
		}
	}
	ds_list_clear(block_list);
	return false;
}

function entity_position_collide()
{
	/// @description entity_position_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	//return entity_position_meeting(xx+offsetX,yy+offsetY,"ISolid") || entity_position_meeting(xx+offsetX,yy+offsetY,"INPCSolid");
	if(lhc_position_meeting(xx+offsetX,yy+offsetY,"ISolid") || lhc_position_meeting(xx+offsetX,yy+offsetY,"INPCSolid"))
	{
		var num = instance_position_list(xx+offsetX,yy+offsetY,all,block_list,true);
		for(var i = 0; i < num; i++)
		{
			if(instance_exists(block_list[| i]) && (asset_has_any_tag(block_list[| i].object_index,"ISolid",asset_object) || asset_has_any_tag(block_list[| i].object_index,"INPCSolid",asset_object)) && !asset_has_any_tag(block_list[| i].object_index,"IMovingSolid",asset_object))
			{
				ds_list_clear(block_list);
				return true;
			}
		}
	}
	ds_list_clear(block_list);
	return false;
}

function entity_collision_line(x1,y1,x2,y2, prec = true, notme = true)
{
	//return lhc_collision_line(x1,y1,x2,y2,"ISolid",prec,notme) || lhc_collision_line(x1,y1,x2,y2,"INPCSolid",prec,notme);
	if(lhc_collision_line(x1,y1,x2,y2,"ISolid",prec,notme) || lhc_collision_line(x1,y1,x2,y2,"INPCSolid",prec,notme))
	{
		var num = collision_line_list(x1,y1,x2,y2,all,true,true,block_list,true);
		for(var i = 0; i < num; i++)
		{
			if(instance_exists(block_list[| i]) && (asset_has_any_tag(block_list[| i].object_index,"ISolid",asset_object) || asset_has_any_tag(block_list[| i].object_index,"INPCSolid",asset_object)) && !asset_has_any_tag(block_list[| i].object_index,"IMovingSolid",asset_object))
			{
				ds_list_clear(block_list);
				return true;
			}
		}
	}
	ds_list_clear(block_list);
	return false;
}

function OnXCollision(fVX)
{
	velX = 0;
	fVelX = 0;
}
function OnYCollision(fVY)
{
	velY = 0;
	fVelY = 0;
}

#endregion

#region GetEdgeSlope
function GetEdgeSlope()
{
	/// @description GetEdgeSlope
	/// @param edge
	/// @param margin=0
	var edge = argument[0];
	
	var xcheck = 0,
		ycheck = 2;
	switch (edge)
	{
		case Edge.Top:
		{
			xcheck = 0;
			ycheck = -2;
			break;
		}
		case Edge.Left:
		{
			xcheck = -2;
			ycheck = 0;
			break;
		}
		case Edge.Right:
		{
			xcheck = 2;
			ycheck = 0;
			break;
		}
		default:
		{
			break;
		}
	}
	
	var margin = 0;
	if(argument_count > 1)
	{
		margin = argument[1];
	}
		
	var col = instance_place_list(x+xcheck,y+ycheck,all,edgeSlope,true);
	if(col > 0)
	{
		for(var i = 0; i < col; i++)
		{
			if(!instance_exists(edgeSlope[| i]) || (!asset_has_any_tag(edgeSlope[| i].object_index,"ISolid",asset_object) && !asset_has_any_tag(edgeSlope[| i].object_index,"INPCSolid",asset_object)) || asset_has_any_tag(edgeSlope[| i].object_index,"IMovingSolid",asset_object) || !asset_has_any_tag(edgeSlope[| i].object_index,"ISlope",asset_object))
			{
				continue;
			}
			var slope = edgeSlope[| i];
			if(instance_exists(slope))
			{
				var withinX = (slope.image_xscale > 0 && bbox_left >= slope.bbox_left-margin) || (slope.image_xscale < 0 && bbox_right <= slope.bbox_right+margin),
					withinY = (slope.image_yscale > 0 && bbox_bottom <= slope.bbox_bottom+margin) || (slope.image_yscale < 0 && bbox_top >= slope.bbox_top-margin);
				var checkHor = ((edge == Edge.Bottom && slope.image_yscale > 0) || (edge == Edge.Top && slope.image_yscale < 0)) && withinX,
					checkVer = ((edge == Edge.Left && slope.image_xscale > 0) || (edge == Edge.Right && slope.image_xscale < 0)) && withinY;
				if(checkHor || checkVer)
				{
					ds_list_clear(edgeSlope);
					return slope;
				}
			}
		}
	}
	ds_list_clear(edgeSlope);
	
	return noone;
}
#endregion