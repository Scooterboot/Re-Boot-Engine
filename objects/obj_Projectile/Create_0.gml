/// @description Initialize
event_inherited();

#region BBox vars
function bb_left(xx = undefined)
{
	/// @description bb_left
	/// @param baseX=x
	xx = is_undefined(xx) ? x : xx;
	return bbox_left-x + xx;
}
function bb_right(xx = undefined)
{
	/// @description bb_right
	/// @param baseX=x
	xx = is_undefined(xx) ? x : xx;
	return bbox_right-x + xx - 1;
}
function bb_top(yy = undefined)
{
	/// @description bb_top
	/// @param baseY=y
	yy = is_undefined(yy) ? y : yy;
	return bbox_top-y + yy;
}
function bb_bottom(yy = undefined)
{
	/// @description bb_bottom
	/// @param baseY=y
	yy = is_undefined(yy) ? y : yy;
	return bbox_bottom-y + yy - 1;
}
#endregion

#region Initialize Base Variables

image_speed = 0;

enum ProjStyle
{
	Default,
	Wave,
	Spazer
}
projStyle = ProjStyle.Default;

hostile = false;
tileCollide = true;
multiHit = false;
timeLeft = 300;

isCharge = false;

damage = 0;
dmgDelay = 0;
npcDeathType = -1;

ignoreCamera = false;
extCamRange = 48;
outsideCam = 0;

creator = noone;

particleType = -1;
impactSnd = noone;

impacted = 0;
dmgImpacted = false;
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

speed_x = 0;
speed_y = 0;

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

#endregion

#region Damage

dmgBoxMask = noone;
dmgBoxOffsetX = 0;
dmgBoxOffsetY = 0;
function DamageBoxes()
{
	if(damage > 0)
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
			dmgBoxes[0].mask_index = _mask;
			dmgBoxes[0].image_xscale = image_xscale;
			dmgBoxes[0].image_yscale = image_yscale;
			dmgBoxes[0].image_angle = image_angle;
			dmgBoxes[0].direction = direction;
			dmgBoxes[0].Damage(x,y,damage,damageType,damageSubType,freezeType,freezeTime,npcDeathType);
		}
		
		if(projLength > 0)
		{
			var numw = max(abs(bb_right(0) - bb_left(0)),1),
		        numd = max(scr_ceil(clamp(point_distance(x,y,xstart,ystart),1,projLength) / numw), 1);
			
			for(var i = 1; i < numd; i++)
			{
				var xw = x-lengthdir_x(numw*i,direction),
					yw = y-lengthdir_y(numw*i,direction);
				
				if(array_length(dmgBoxes) < i+1)
				{
					dmgBoxes[i] = noone;
				}
				
				if(!instance_exists(dmgBoxes[i]))
				{
					dmgBoxes[i] = self.CreateDamageBox(dmgBoxOffsetX,dmgBoxOffsetY,_mask,hostile);
				}
				else
				{
					dmgBoxes[i].mask_index = _mask;
					dmgBoxes[i].image_xscale = image_xscale;
					dmgBoxes[i].image_yscale = image_yscale;
					dmgBoxes[i].image_angle = image_angle;
					dmgBoxes[i].direction = direction;
					dmgBoxes[i].Damage(xw,yw,damage,damageType,damageSubType,freezeType,freezeTime,npcDeathType);
				}
			}
		}
	}
}

function Entity_CanDealDamage(_selfDmgBox, _lifeBox, _damage, _dmgType, _dmgSubType)
{
	return (!dmgImpacted);
}

function DmgPartEmitRegion(partSys, partEmit, _selfDmgBox, _lifeBox)
{
	var partX1 = max(_selfDmgBox.bb_left()+4, _lifeBox.bb_left()),
		partX2 = min(_selfDmgBox.bb_right()-4, _lifeBox.bb_right()),
		partY1 = max(_selfDmgBox.bb_top()+4, _lifeBox.bb_top()),
		partY2 = min(_selfDmgBox.bb_bottom()-4, _lifeBox.bb_bottom());
	
	part_emitter_region(partSys,partEmit,partX1,partX2,partY1,partY2,ps_shape_ellipse,ps_distr_linear);
}

function Entity_OnDamageDealt(_selfDmgBox, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType)
{
	var partSys = obj_Particles.partSystemA,
		partEmit = obj_Particles.partEmitA;
	self.DmgPartEmitRegion(partSys, partEmit, _selfDmgBox, _lifeBox);
	
	var ent = _lifeBox.creator;
	if(freezeType > 0 && !ent.freezeImmune)
	{
		part_emitter_burst(partSys,partEmit,obj_Particles.partFreeze,21*(1+isCharge));
	}
}
function Entity_OnDamageDealt_Blocked(_selfDmgBox, _lifeBox, _dmg, _dmgType, _dmgSubType)
{
	var partSys = obj_Particles.partSystemA,
		partEmit = obj_Particles.partEmitA;
	self.DmgPartEmitRegion(partSys, partEmit, _selfDmgBox, _lifeBox);
	
	var ent = _lifeBox.creator;
	
	if(freezeType > 0 && !ent.freezeImmune)
	{
		part_emitter_burst(partSys,partEmit,obj_Particles.partFreeze,21*(1+isCharge));
	}
	else if(_dmgType != DmgType.ExplSplash)
	{
		if(ent.dmgAbsorb)
		{
			audio_stop_sound(snd_ProjAbsorbed);
			audio_play_sound(snd_ProjAbsorbed,0,false);
				
			part_particles_create(partSys,x,y,obj_Particles.partAbsorb,1);
		}
		else if(!reflected || multiHit)
		{
			reflected = true;
				
			audio_stop_sound(snd_Reflect);
			audio_play_sound(snd_Reflect,0,false);
				
			part_emitter_burst(partSys,partEmit,obj_Particles.partDeflect,42);
		}
	}
	
	if(particleType != -1)
	{
		var partAmt = 7*(1+isCharge);
		if(multiHit)
		{
			partAmt = (1+isCharge);
		}
		part_emitter_burst(partSys,partEmit,obj_Particles.bTrails[particleType],partAmt);
	}
}

function Entity_OnDmgBoxCollision(_selfDmgBox, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType)
{
	var partSys = obj_Particles.partSystemA,
		partEmit = obj_Particles.partEmitA;
	self.DmgPartEmitRegion(partSys, partEmit, _selfDmgBox, _lifeBox);
	
	var ent = _lifeBox.creator;
	if(_finalDmg > 0)
	{
		if(particleType != -1 && multiHit)
		{
			part_emitter_burst(partSys,partEmit,obj_Particles.bTrails[particleType],(1+isCharge));
		}
	}
	
	if(!multiHit)
	{
		impacted = max(impacted,1);
		dmgImpacted = true;
	}
}

#endregion

#region Base Collision
function CanPlatformCollide()
{
	return false;
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

function OnImpact(posX, posY, silentImpact = false)
{
	if(impactSnd != noone && !silentImpact)
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
	self.BreakBlock(_x,_y,blockBreakType);
	self.OpenDoor(_x,_y,doorOpenType);
	self.ShutterSwitch(_x,_y,doorOpenType);
}