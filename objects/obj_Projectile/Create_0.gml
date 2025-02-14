/// @description Initialize
event_inherited();

#region BBox vars
function bb_left()
{
	/// @description bb_left
	/// @param baseX=x
	var xx = x;
	if(argument_count > 0)
	{
		xx = argument[0];
	}
	return bbox_left-x + xx;
}
function bb_right()
{
	/// @description bb_right
	/// @param baseX=x
	var xx = x;
	if(argument_count > 0)
	{
		xx = argument[0];
	}
	return bbox_right-x + xx - 1;
}
function bb_top()
{
	/// @description bb_top
	/// @param baseY=y
	var yy = y;
	if(argument_count > 0)
	{
		yy = argument[0];
	}
	return bbox_top-y + yy;
}
function bb_bottom()
{
	/// @description bb_bottom
	/// @param baseY=y
	var yy = y;
	if(argument_count > 0)
	{
		yy = argument[0];
	}
	return bbox_bottom-y + yy - 1;
}
#endregion

#region Initialize Base Variables

image_speed = 0;

aiStyle = 0;
hostile = false;
tileCollide = true;
multiHit = false;
timeLeft = 300;

isCharge = false;

damage = 0;
damageType = DmgType.Beam;
damageSubType[0] = true; // all
damageSubType[1] = false; // power beam (Beam/Charge) | missile (Explosive) | grapple beam (Misc)
damageSubType[2] = false; // ice beam (Beam/Charge) | super missile (Explosive) | speed boost/shine spark (Misc)
damageSubType[3] = false; // wave beam (Beam/Charge) | bomb (Explosive) | screw attack (Misc)
damageSubType[4] = false; // spazer (Beam/Charge) | power bomb (Explosive) | hyper beam (Misc)
damageSubType[5] = false; // plasma beam (Beam/Charge) | splash damage (Explosive) | boost ball (Misc)

freezeType = 0;
freezeKill = false;

knockBack = 4;//9;
knockBackSpeed = 5;
damageInvFrames = 96;

dmgDelay = 0;

ignoreCamera = false;
extCamRange = 48;
outsideCam = 0;

npcInvFrames[instance_number(obj_NPC)] = 0;
npcDeathType = -1;

creator = noone;

particleType = -1;
impactSnd = noone;

impacted = 0;
reflected = false;

shift = 0;
prevShift = 0;
t = 0;
t2 = 0;
increment = pi*2 / 60;
xx = x;
yy = y;
dir = 1;

waveStyle = 0;
waveDir = 1;

amplitude = 0;
wavesPerSecond = 0;
delay = 0;

lastReflec = noone;
reflecList = ds_list_create();

//speed = 0;
//velocity = 0;
//direction = 0;
//image_angle = direction;
speed_x = 0;
speed_y = 0;

//particleDelay = 0;
rotation = direction;
for(var i = 0; i < 11; i++)
{
	oldPosX[i] = x;
	oldPosY[i] = y;
}
for(var i = 0; i < 11; i++)
{
	oldRot[i] = rotation;
}
oldPositionsSet = false;

enum ProjType
{
	Beam,
	Missile,
	Bomb
}
type = ProjType.Beam;

projLength = 0;
rotFrame = 0;

//frame = 0;
//frameCounter = 0;

#endregion

#region Damage

function CanDamageNPC(damage,npc)
{
	return true;
}
function ModifyDamageNPC(damage,npc)
{
	return damage;
}
function OnDamageNPC(damage,npc) {}

#endregion

#region Base Collision
function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = position.X,
		yy = position.Y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	return entity_collision(instance_place_list(xx+offsetX,yy+offsetY,solids,blockList,true));
}

function entity_collision(listNum)
{
	if(listNum > 0)
	{
		for(var i = 0; i < listNum; i++)
		{
			if(instance_exists(blockList[| i]))
			{
				var block = blockList[| i];
				var isSolid = true;
				if(tileCollide && type != ProjType.Bomb && array_contains(doorOpenType, true))
				{
					if(object_is_ancestor(block.object_index,obj_DoorHatch))
					{
						if(!block.unlocked ||
						(!doorOpenType[DoorOpenType.Beam] && block.object_index == obj_DoorHatch_Blue) ||
						(!doorOpenType[DoorOpenType.Missile] && block.object_index == obj_DoorHatch_Missile) ||
						(!doorOpenType[DoorOpenType.SMissile] && block.object_index == obj_DoorHatch_Super) ||
						(!doorOpenType[DoorOpenType.PBomb] && block.object_index == obj_DoorHatch_Power))
						{
							isSolid = false;
						}
					}
					if(instance_exists(lastReflec) && block == lastReflec)
					{
						isSolid = false;
					}
				}
				if(isSolid)
				{
					ds_list_clear(blockList);
					return true;
				}
			}
		}
	}
	ds_list_clear(blockList);
	return false;
}

#endregion

function OnImpact(posX,posY,waveImpact = false)
{
	if(impactSnd != noone && !waveImpact)
	{
		if(audio_is_playing(impactSnd))
		{
			audio_stop_sound(impactSnd);
		}
		audio_play_sound(impactSnd,0,false);
	}
	if(particleType != -1 && particleType <= 4)
	{
		part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.bTrails[particleType],7*(1+isCharge));
		if(isCharge)
		{
			part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.cImpact[particleType],1);
		}
		else
		{
			part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.impact[particleType],1);
		}
	}
}

function TileInteract(_x,_y)
{
	BreakBlock(_x,_y,blockBreakType);
	OpenDoor(_x,_y,doorOpenType);
	ShutterSwitch(_x,_y,doorOpenType);
}