/// @description Behavior

#region Misc Behavior and Trails
if(isWave)
{
	layer = layer_get_id("Projectiles_fg");
}

//water_update(isWave,x-xprevious,y-yprevious);

var pNum = 7,
	pType = -1;
if(particleType != -1)
{
	pType = obj_Particles.bTrails[particleType];
}

var partSys = obj_Particles.partSystemC;
if(isWave)
{
	partSys = obj_Particles.partSystemA;
}

if(!global.gamePaused)
{
	if(!InWater || (isWave && !isIce && !isPlasma))
	{
		var num = 3 - (isCharge*2);
		if(isPlasma)
		{
			num = 2 - isCharge;
		}
		else if(isWave)
		{
			num = 2*(!isCharge);
		}
		if(pType != -1)
		{
			if(sprite_width > sprite_height)
			{
				var offset = ceil(sprite_yoffset/2),
					dist = clamp(abs(point_distance(x,y,xstart,ystart))/sprite_width,0,1),
					len = max(sprite_xoffset-(sprite_width-sprite_xoffset),point_distance(x,y,xprevious,yprevious))*dist,
					ang = image_angle,
					x1 = x+lengthdir_x(offset,ang+90), x2 = x-lengthdir_x(len,ang)+lengthdir_x(offset,ang+90),
					y1 = y+lengthdir_y(offset,ang+90), y2 = y-lengthdir_y(len,ang)+lengthdir_y(offset,ang+90);
				if(!part_emitter_exists(partSys,emit))
				{
					emit = part_emitter_create(partSys);
				}
				part_emitter_region(partSys,emit,x1,x2,y1,y2,ps_shape_line,ps_distr_linear);
				part_emitter_burst(partSys,emit,pType,pNum / max(num,1) / 1.5);
				
				var x3 = x+lengthdir_x(offset,ang-90), x4 = x-lengthdir_x(len,ang)+lengthdir_x(offset,ang-90),
					y3 = y+lengthdir_y(offset,ang-90), y4 = y-lengthdir_y(len,ang)+lengthdir_y(offset,ang-90);
				
				part_emitter_region(partSys,emit,x3,x4,y3,y4,ps_shape_line,ps_distr_linear);
				part_emitter_burst(partSys,emit,pType,pNum / max(num,1) / 1.5);
			}
			else
			{
				var x1 = bbox_left+2, x2 = bbox_right-1,
					y1 = bbox_top+2, y2 = bbox_bottom-1;
				if(!part_emitter_exists(partSys,emit))
				{
					emit = part_emitter_create(partSys);
				}
				part_emitter_region(partSys,emit,x1,x2,y1,y2,ps_shape_ellipse,ps_distr_linear);
				part_emitter_burst(partSys, emit, pType, pNum / max(num,1));
			}
		}
		
		if(isWave && !isIce && !isPlasma)
		{
			particleDelay = max(particleDelay - 1, 0);
			if(particleDelay <= 0)
			{
				part_particles_create(partSys,x,y,obj_Particles.bTrails[5],1);
				particleDelay = 2-isCharge;
			}
		}
	}
	else
	{
		//bubbles?
	}
}

/*for(var i = 0; i < instance_number(obj_NPC); i++)
{
	if(i >= array_length_1d(npcImmuneTime) && i < instance_number(obj_NPC))
	{
		npcImmuneTime[i] = 0;
	}
	else
	{
		npcImmuneTime[i] = max(npcImmuneTime[i]-1,0);
	}
}*/
#endregion

event_inherited();