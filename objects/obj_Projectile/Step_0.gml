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
#region Weapon Behavior
var xspeed = lengthdir_x(velocity,direction),
	yspeed = lengthdir_y(velocity,direction);

if(creator == obj_Player)
{
	if(sign(xspeed) == sign(creator.hSpeed) && abs(speed_x) < abs(creator.hSpeed))
	{
		speed_x = creator.hSpeed;
	}
	if(sign(yspeed) == sign(creator.vSpeed) && abs(speed_y) < abs(creator.vSpeed))
	{
		speed_y = creator.vSpeed;
	}
}

xspeed += speed_x;
yspeed += speed_y;

if(tileCollide && impact == 0)
{
	var counter = abs(xspeed)+abs(yspeed);
	if(position_collide(xspeed,yspeed) || position_collide(0,0) || collision_line(xprevious-xspeed,yprevious-yspeed,x+xspeed,y+yspeed,obj_Tile,true,true))
	{
		while(!position_collide(sign(xspeed),sign(yspeed)) && !position_collide(0,0) && !collision_line(xprevious-xspeed,yprevious-yspeed,x+sign(xspeed),y+sign(yspeed),obj_Tile,true,false) && counter > 0)
		{
			x += sign(xspeed);
			y += sign(yspeed);
			counter--;
		}
		velocity = 0;
		speed_x = 0;
		speed_y = 0;
		if(audio_is_playing(impactSnd))
		{
			audio_stop_sound(impactSnd);
		}
		audio_play_sound(impactSnd,0,false);
		xspeed = 0;
		yspeed = 0;
		if(particleType != -1)
		{
			part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.bTrails[particleType],7*(1+isCharge));
			if(isCharge)
			{
				part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.cImpact[particleType],1);
			}
			else
			{
				part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.impact[particleType],1);
			}
		}
		impact = 1;
	}
}

if(!isMissile)
{
	/*if(tileCollide && impact == 0 && place_meeting(x,y,obj_ShotBlock))
	{
		
	}*/
	//scr_OpenDoor(x,y);
	//scr_BreakBlock(x,y,0);
	if(impact > 0)
	{
		//scr_OpenDoor(x+sign(xspeed),y+sign(yspeed));
		//scr_BreakBlock(x+sign(xspeed),y+sign(yspeed),0);
		//scr_OpenDoor(x-xspeed,y-yspeed);
		//scr_BreakBlock(x-xspeed,y-yspeed,0);
	}
	if(sprite_width > sprite_height)
	{
		var numw = abs(bbox_right - bbox_left),
		numd = clamp(abs(point_distance(x,y,xstart,ystart))/sprite_width,0,1);
		for(i = 0; i < max((sprite_width/numw)*numd,1); i++)
		{
			if(i > 0)
			{
				//var xw = x-lengthdir_x(numw*i,direction),
				//	yw = y-lengthdir_y(numw*i,direction);
				//scr_OpenDoor(xw,yw);
				//scr_BreakBlock(xw,yw,0);
			}
		}
	}
}

if(aiStyle == 0)
{
	if(x <= -(velocity*2) || x >= room_width+(velocity*2) || y <= -(velocity*2) || y >= room_height+(velocity*2))
	{
		instance_destroy();
	}
	
	if(!global.gamePaused && impact <= 0)
	{
		x += xspeed;
		y += yspeed;
	}
}
if(aiStyle == 1 || aiStyle == 2)
{
	if(x <= -(amplitude*2) || x >= room_width+(amplitude*2) || y <= -(amplitude*2) || y >= room_height+(amplitude*2))
	{
		instance_destroy();
	}
	
	if(!global.gamePaused)
	{
		var i = 1;
		if(waveStyle == 1)
		{
			i = -1;
		}
		if(waveStyle == 2)
		{
			i = 0;
		}
		if(delay <= 0)
		{
			if(aiStyle == 2)
			{
				t = min(t + increment * wavesPerSecond, pi/2);
			}
			else
			{
				t += increment * wavesPerSecond;
			}
			if(t >= pi*2)
			{
				t -= pi*2;
			}
		}
		delay = max(delay - 1, 0);
		i *= dir;
		if(isWave && !isSpazer)
		{
			i *= waveDir;
		}
		shift = amplitude * sin(t) * i;
		
		xx += xspeed;
		yy += yspeed;
	}
	if(impact <= 0)
	{
		x = xx + lengthdir_x(shift, direction + 90);
		y = yy + lengthdir_y(shift, direction + 90);
	}
}

// damage

if(impact > 0)
{
	if(impact > 1 || isMissile)
	{
		instance_destroy();
	}
	impact += 1;
}

if(instance_exists(obj_Camera) && point_distance(x,y,obj_Camera.x+global.resWidth/2,obj_Camera.y+global.resHeight/2) > global.resWidth*1.375)
{
	instance_destroy();
}
#endregion