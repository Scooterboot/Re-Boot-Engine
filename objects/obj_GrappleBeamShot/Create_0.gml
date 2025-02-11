event_inherited();

damageType = 3;
damageSubType[1] = true;

particleType = 1;

shootDir = 0;
grappleDist = 0;
//grappled = false;
//grappled2 = false;

enum GrappleState
{
	None,
	Swing,
	PushBlock
}
grappleState = GrappleState.None;

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
	ds_list_clear(gp_list);
	return false;
}

function CanDamageNPC(damage,npc)
{
	if(object_is_in_array(npc.object_index, global.colArr_GrapplePoint))
	{
		return false;
	}
	return true;
}

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
}