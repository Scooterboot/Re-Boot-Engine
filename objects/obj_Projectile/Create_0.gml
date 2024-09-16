/// @description Initialize
event_inherited();

#region Initialize Base Variables

image_speed = 0;

aiStyle = 0;
hostile = false;
tileCollide = true;
multiHit = false;
timeLeft = 300;

isCharge = false;

damage = 0;
damageType = 0;
damageSubType[0] = true;
damageSubType[1] = false;
damageSubType[2] = false;
damageSubType[3] = false;
damageSubType[4] = false;
damageSubType[5] = false;

freezeType = 0;
freezeKill = false;

knockBack = 4;//9;
knockBackSpeed = 5;
damageInvFrames = 96;

dmgDelay = 0;

ignoreCamera = false;

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


blockDestroyType = 0;
doorOpenType = 0;

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
	
	return entity_collision(instance_place_list(xx+offsetX,yy+offsetY,all,blockList,true));
}

function entity_collision(listNum)
{
	for(var i = 0; i < listNum; i++)
	{
		if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,solids,asset_object))
		{
			var block = blockList[| i];
			var isSolid = true;
			if(type != ProjType.Bomb && doorOpenType >= 0 && tileCollide)
			{
				if(block.object_index == obj_DoorHatch || object_is_ancestor(block.object_index,obj_DoorHatch))
				{
					if((!block.unlocked ||
					(doorOpenType <= -1 && block.object_index == obj_DoorHatch) ||
					(doorOpenType != 1 && doorOpenType != 2 && block.object_index == obj_DoorHatch_Missile) ||
					(doorOpenType != 2 && block.object_index == obj_DoorHatch_Super) ||
					(doorOpenType != 3 && block.object_index == obj_DoorHatch_Power)) && doorOpenType != 4)
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
	BreakBlock(_x,_y,blockDestroyType);
	OpenDoor(_x,_y,doorOpenType);
	ShutterSwitch(_x,_y,doorOpenType);
}