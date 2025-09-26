/// @description Behavior

#region Misc Behavior and Trails
if(isWave)
{
	layer = layer_get_id("Projectiles_fg");
}

self.EntityLiquid(!isWave,x-xprevious,y-yprevious,true,true,false);

var pNum = 7,
	pType = -1;
if(particleType != -1)
{
	pType = obj_Particles.bTrails[particleType];
}

var partSys = obj_Particles.partSystemC,
	partEmit = obj_Particles.partEmitC;
if(isWave)
{
	partSys = obj_Particles.partSystemA;
	partEmit = obj_Particles.partEmitA;
}

if(!global.GamePaused())
{
	if(!liquid || (isWave && !isIce && !isPlasma))
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
			if(particleDelay2 <= 0)
			{
				if(projLength > 0)
				{
					var offset = ceil(sprite_yoffset/2),
						len = clamp(point_distance(x,y,xstart,ystart),1,projLength),
						ang = direction;
				
					var x1 = x+lengthdir_x(offset,ang+90), x2 = x-lengthdir_x(len,ang)+lengthdir_x(offset,ang+90),
						y1 = y+lengthdir_y(offset,ang+90), y2 = y-lengthdir_y(len,ang)+lengthdir_y(offset,ang+90);
				
					part_emitter_region(partSys,partEmit,x1,x2,y1,y2,ps_shape_line,ps_distr_linear);
					part_emitter_burst(partSys,partEmit,pType,pNum / max(num,1) / 1.5);
				
					var x3 = x+lengthdir_x(offset,ang-90), x4 = x-lengthdir_x(len,ang)+lengthdir_x(offset,ang-90),
						y3 = y+lengthdir_y(offset,ang-90), y4 = y-lengthdir_y(len,ang)+lengthdir_y(offset,ang-90);
				
					part_emitter_region(partSys,partEmit,x3,x4,y3,y4,ps_shape_line,ps_distr_linear);
					part_emitter_burst(partSys,partEmit,pType,pNum / max(num,1) / 1.5);
				}
				else
				{
					var x1 = self.bb_left()+2, x2 = self.bb_right()-2,
						y1 = self.bb_top()+2, y2 = self.bb_bottom()-2;
				
					part_emitter_region(partSys,partEmit,x1,x2,y1,y2,ps_shape_ellipse,ps_distr_linear);
					part_emitter_burst(partSys, partEmit, pType, pNum / max(num,1));
				}
				particleDelay2 = irandom(1);
			}
			else
			{
				particleDelay2--;
			}
		}
		
		if(particleDelay <= 0)
		{
			if(isIce)
			{
				part_particles_create(partSys,x,y,obj_Particles.bTrails[6],1);
				particleDelay = irandom_range(2,4)-isCharge;
			}
			else if(isWave && !isPlasma)
			{
				part_particles_create(partSys,x,y,obj_Particles.bTrails[5],1);
				particleDelay = irandom_range(2,4)-isCharge;
			}
		}
		else
		{
			particleDelay--;
		}
	}
	else if(liquid)
	{
		var x1 = self.bb_left()+2, x2 = self.bb_right()-2,
			y1 = self.bb_top()+2, y2 = self.bb_bottom()-2;
		var bub = liquid.CreateBubble(random_range(x1,x2),random_range(y1,y2),0,0);
		if(!isPlasma && !isCharge)
		{
			bub.spriteIndex = sprt_WaterBubbleTiny;
		}
		if(isCharge)
		{
			bub.spriteIndex = sprt_WaterBubble;
		}
		bub.kill = true;
		bub.canSpread = (irandom(1) == 0);
		bub.alpha = 0.7 + random(0.2);
		bub.maxSpeed /= (1 + random(0.3));
	}
}

#endregion

event_inherited();