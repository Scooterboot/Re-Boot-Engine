event_inherited();

damageType = DmgType.Misc;
damageSubType = array_create(DmgSubType_Misc._Length,false);
damageSubType[DmgSubType_Misc.All] = true;
damageSubType[DmgSubType_Misc.Grapple] = true;

particleType = 1;

shootDir = 0;
grappleDist = 0;
grappled = false;
//grappled2 = false;

enum GrappleState
{
	None,
	Swing,
	PushBlock
}
grappleState = GrappleState.None;
stateChanged = false;

grapBlock = noone;
grapBlockPosX = -1;//0;
grapBlockPosY = -1;//0;
grapSpeed = 0;
grapSpeedMax = 28;//16;

drawGrapEffect = false;
grapFrame = 0;

direction = 0;
speed = 0;
image_speed = 0.5;

drawGrapDelay = 1;

//timeLeft = 8;

//isGrapple = true;

gp_list = ds_list_create();

function entity_collision_line(x1,y1,x2,y2, prec = true, notme = true)
{
	var num = collision_line_list(x1,y1,x2,y2,solids,prec,notme,gp_list,true);
	if(num > 0)
	{
		for(var i = 0; i < num; i++)
		{
			if(instance_exists(gp_list[| i]))
			{
				var col = gp_list[| i];
			
				var flag = true;
				if(col.object_index == obj_MovingTile || object_is_ancestor(col.object_index,obj_MovingTile))
				{
					flag = col.grappleCollision;
				}
				if(flag)
				{
					ds_list_clear(gp_list);
					return true;
				}
			}
		}
	}
	ds_list_clear(gp_list);
	return false;
}

function Entity_CanDealDamage(_selfDmgBox, _lifeBox, _damage, _dmgType, _dmgSubType)
{
	if(object_is_in_array(_lifeBox.creator.object_index, ColType_GrapplePoint))
	{
		return false;
	}
	return true;
}
function DamageBoxes()
{
	if(damage > 0)
	{
		if(!instance_exists(dmgBoxes[0]))
		{
			dmgBoxes[0] = self.CreateDamageBox(0,0,mask_index,hostile);
		}
		else
		{
			dmgBoxes[0].mask_index = mask_index;
			dmgBoxes[0].image_xscale = image_xscale;
			dmgBoxes[0].image_yscale = image_yscale;
			dmgBoxes[0].image_angle = image_angle;
			dmgBoxes[0].direction = direction;
			dmgBoxes[0].Damage(x,y,damage,damageType,damageSubType,freezeType,freezeTime,npcDeathType);
		}
		
		var player = creator;
		var sPosX = player.x+player.sprtOffsetX+player.armOffsetX,
			sPosY = player.y+player.sprtOffsetY+player.runYOffset+player.armOffsetY;
		var numw = 8,
			numd = max(scr_ceil(point_distance(sPosX,sPosY, x,y) / numw), 1);
		
		for(var i = 1; i < numd; i++)
		{
			var _dir = point_direction(sPosX,sPosY, x,y);
			var xw = x-lengthdir_x(numw*i,_dir),
				yw = y-lengthdir_y(numw*i,_dir);
			
			if(array_length(dmgBoxes) < i+1)
			{
				dmgBoxes[i] = noone;
			}
			
			if(!instance_exists(dmgBoxes[i]))
			{
				dmgBoxes[i] = self.CreateDamageBox(0,0,mask_index,hostile);
			}
			if(instance_exists(dmgBoxes[i]))
			{
				dmgBoxes[i].mask_index = mask_index;
				dmgBoxes[i].image_xscale = image_xscale;
				dmgBoxes[i].image_yscale = image_yscale;
				dmgBoxes[i].image_angle = image_angle;
				dmgBoxes[i].direction = direction;
				dmgBoxes[i].Damage(xw,yw,damage,damageType,damageSubType,freezeType,freezeTime,npcDeathType);
			}
		}
		
		for(var i = numd; i < array_length(dmgBoxes); i++)
		{
			instance_destroy(dmgBoxes[i]);
		}
	}
}

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
	
	part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.gTrail,7);
	part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.gImpact,1);
	
	var ddepth = layer_get_depth(layer_get_id("Projectiles_fg"))+1;
	var dist = instance_create_depth(0,0,ddepth,obj_Distort);
	dist.left = posX-8;
	dist.right = posX+8;
	dist.top = posY-8;
	dist.bottom = posY+8;
	dist.alpha = 0;
	dist.alphaNum = 1;
	dist.alphaRate = 0.125;
	dist.alphaRateMultDecr = 4;
	dist.colorMult = 0.05;
	dist.spread = 0.5;
	dist.width = 0.5;
}