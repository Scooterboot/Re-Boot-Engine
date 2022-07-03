/// @description Behavior

#region Weapon Behavior (old)
/*var xspeed = lengthdir_x(velocity,direction),
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
	if(lhc_position_collide(xspeed,yspeed) || lhc_position_collide(0,0) || lhc_collision_line(xprevious-xspeed,yprevious-yspeed,x+xspeed,y+yspeed,"ISolid",true,true))
	{
		while(!lhc_position_collide(sign(xspeed),sign(yspeed)) && !lhc_position_collide(0,0) && !lhc_collision_line(xprevious-xspeed,yprevious-yspeed,x+sign(xspeed),y+sign(yspeed),"ISolid",true,false) && counter > 0)
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
		//xspeed = 0;
		//yspeed = 0;
		if(particleType != -1 && particleType <= 4)
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

projWidth = abs(bbox_right - bbox_left);

if(!isMissile)
{
	scr_OpenDoor(x,y,0);
	scr_BreakBlock(x,y,0);
	if(impact > 0)
	{
		scr_OpenDoor(x+xspeed,y+yspeed,0);
		scr_BreakBlock(x+xspeed,y+yspeed,0);
		scr_OpenDoor(x-xspeed,y-yspeed,0);
		scr_BreakBlock(x-xspeed,y-yspeed,0);
	}
	if(projLength > 0)
	{
		var numw = max(projWidth,1),//sprite_xoffset*2,//abs(bbox_right - bbox_left),
            numd = clamp(point_distance(x,y,xstart,ystart),1,projLength);
		for(var j = -numw; j < numd; j += numw)
		{
			//if(j > 0)
			//{
				var xw = x-lengthdir_x(j,direction),
					yw = y-lengthdir_y(j,direction);
				scr_OpenDoor(xw,yw,0);
				scr_BreakBlock(xw,yw,0);
			//}
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
		if(waveStyle >= 3)
		{
			i = scr_ceil(waveStyle/2);
			if(waveStyle%2 == 0)
			{
				i *= -1;
			}
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
			
			if(waveStyle >= 3 && aiStyle == 1)
			{
				t2 = min(t2 + increment * (wavesPerSecond / 2) * (abs(i)-1), (pi / 2) * (abs(i)-1));
			}
		}
		delay = max(delay - 1, 0);
		i *= dir;
		if(isWave && !isSpazer)
		{
			i *= waveDir;
		}
		shift = amplitude * sin(t - t2) * i;
		
		xx += xspeed;
		yy += yspeed;
	}
	if(impact <= 0)
	{
		x = xx + lengthdir_x(shift, direction + 90);
		y = yy + lengthdir_y(shift, direction + 90);
	}
}

var freezeType = 0,
    deathType = -1,
    immuneTime = 4;

if(isIce)
{
    freezeType = 1 + isCharge;
}

if(!global.gamePaused && damage > 0)
{
    var player = noone;
	if(projLength > 0)
    {
        var numw = max(projWidth,1),//sprite_xoffset*2,//abs(bbox_right - bbox_left),
            numd = clamp(point_distance(x,y,xstart,ystart),1,projLength);
		for(var j = -numw; j < numd; j += numw)
        {
            //if(j > 0)
            //{
                var xw = x-lengthdir_x(j,direction),
                    yw = y-lengthdir_y(j,direction);
				
				if(hostile)
				{
					if(place_meeting(xw,yw,obj_Player))
                    {
                        player = instance_place(xw,yw,obj_Player);
                    }
				}
				else
				{
					scr_DamageNPC(xw,yw,damage,damageType,damageSubType,freezeType,deathType,immuneTime);
				}
            //}
        }
    }
	
	if(hostile)
	{
		if(!instance_exists(player) && place_meeting(x,y,obj_Player))
		{
			player = instance_place(x,y,obj_Player);
		}
		if(instance_exists(player))
        {
            if (player.immuneTime <= 0 && !player.isScrewAttacking && !player.isSpeedBoosting)
            {
                //var ang = point_direction(x,y,obj_Player.x,obj_Player.y);
                var ang = 45;
                if(player.y > y)
                {
                    ang = 315;
                }
                if(player.x < x)
                {
                    ang = 135;
                    if(player.y > y)
                    {
                        ang = 225;
                    }
                }
                var knockX = lengthdir_x(knockBackSpeed,ang),
                    knockY = lengthdir_y(knockBackSpeed,ang);
                scr_DamagePlayer(damage,knockBack,knockX,knockY,damageImmuneTime);
                if(!multiHit)
                {
                    instance_destroy();
                }
            }
        }
	}
	else
	{
		scr_DamageNPC(x,y,damage,damageType,damageSubType,freezeType,deathType,immuneTime);
	}
}

if(impact > 0)
{
	if(impact > 1 || isMissile)
	{
		instance_destroy();
	}
	impact += 1;
}

if(!scr_WithinCamRange())
{
	instance_destroy();
}*/
#endregion

#region Projectile Behavior

if(global.gamePaused)
{
	exit;
}

if(creator == obj_Player)
{
	if(sign(velX) == sign(creator.hSpeed) && abs(speed_x) < abs(creator.hSpeed))
	{
		speed_x = creator.hSpeed;
	}
	if(sign(velY) == sign(creator.vSpeed) && abs(speed_y) < abs(creator.vSpeed))
	{
		speed_y = creator.vSpeed;
	}
}

fVelX = velX + speed_x;
fVelY = velY + speed_y;

#region Collision
if(tileCollide && impacted == 0)
{
	//Collision_Normal(fVelX,fVelY,16,16,false,false);
	
	var counter = abs(fVelX)+abs(fVelY);
	if(lhc_position_collide(fVelX,fVelY) || lhc_position_collide(0,0) || lhc_collision_line(xprevious-fVelX,yprevious-fVelY,x+fVelX,y+fVelY,"ISolid",true,true))
	{
		while(!lhc_position_collide(sign(fVelX),sign(fVelY)) && !lhc_position_collide(0,0) && !lhc_collision_line(xprevious-fVelX,yprevious-fVelY,x+sign(fVelX),y+sign(fVelY),"ISolid",true,false) && counter > 0)
		{
			x += sign(fVelX);
			y += sign(fVelY);
			counter--;
		}
		speed_x = 0;
		speed_y = 0;
		fVelX = 0;
		fVelY = 0;
		if(audio_is_playing(impactSnd))
		{
			audio_stop_sound(impactSnd);
		}
		audio_play_sound(impactSnd,0,false);
		if(particleType != -1 && particleType <= 4)
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
		impacted = 1;
	}
		
	x += fVelX;
	y += fVelY;
}
else if(impacted == 0)
{
	x += fVelX;
	y += fVelY;
}
#endregion

#region AI Styles
if(aiStyle == 0)
{
	if(x <= -abs(velX)*2 || x >= room_width+abs(velX)*2 || y <= -abs(velY)*2 || y >= room_height+abs(velY)*2)
	{
		instance_destroy();
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
		/*var i = 1;
		if(waveStyle == 1)
		{
			i = -1;
		}
		if(waveStyle == 2)
		{
			i = 0;
		}
		if(waveStyle >= 3)
		{
			i = scr_ceil(waveStyle/2);
			if(waveStyle%2 == 0)
			{
				i *= -1;
			}
		}*/
		var i = 0;
		if(waveStyle > 0)
		{
			i = scr_ceil(waveStyle/2);
			if(waveStyle%2 == 0)
			{
				i *= -1;
			}
		}
		delay = max(delay - 1, 0);
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
			
			if(waveStyle >= 3 && aiStyle == 1)
			{
				t2 = min(t2 + increment * (wavesPerSecond / 2) * (abs(i)-1), (pi / 2) * (abs(i)-1));
			}
		}
		i *= dir;
		if(isWave && !isSpazer)
		{
			i *= waveDir;
		}
		shift = amplitude * sin(t - t2) * i;
		
		//xx += xspeed;
		//yy += yspeed;
		xx += fVelX;
		yy += fVelY;
	}
	if(impacted <= 0)
	{
		x = xx + lengthdir_x(shift, direction + 90);
		y = yy + lengthdir_y(shift, direction + 90);
		//fVelX += lengthdir_x(shift, direction + 90);
		//fVelY += lengthdir_y(shift, direction + 90);
	}
}
#endregion

#region Damage to enemies & tiles

var deathType = -1,
    immuneTime = 10;//4;

if(impacted > 0)
{
	scr_OpenDoor(x+fVelX,y+fVelY,doorOpenType);
	scr_BreakBlock(x+fVelX,y+fVelY,blockDestroyType);
	scr_OpenDoor(x,y,doorOpenType);
	scr_BreakBlock(x,y,blockDestroyType);
	scr_OpenDoor(x-fVelX,y-fVelY,doorOpenType);
	scr_BreakBlock(x-fVelX,y-fVelY,blockDestroyType);
}
else
{
	scr_OpenDoor(x-fVelX,y-fVelY,doorOpenType);
	scr_BreakBlock(x-fVelX,y-fVelY,blockDestroyType);
	if(!tileCollide)
	{
		scr_OpenDoor(x,y,doorOpenType);
		scr_BreakBlock(x,y,blockDestroyType);
	}
}

var player = noone;
if(projLength > 0)
{
	var numw = max(abs(bbox_right - bbox_left),1),
        numd = clamp(point_distance(x,y,xstart,ystart),1,projLength);
	for(var j = 0; j < numd; j += numw)
	{
		var xw = x-lengthdir_x(j,direction),
			yw = y-lengthdir_y(j,direction);
		if(impacted > 0)
		{
			scr_OpenDoor(xw+fVelX,yw+fVelY,doorOpenType);
			scr_BreakBlock(xw+fVelX,yw+fVelY,blockDestroyType);
			scr_OpenDoor(xw,yw,doorOpenType);
			scr_BreakBlock(xw,yw,blockDestroyType);
			scr_OpenDoor(xw-fVelX,yw-fVelY,doorOpenType);
			scr_BreakBlock(xw-fVelX,yw-fVelY,blockDestroyType);
		}
		else
		{
			scr_OpenDoor(xw-fVelX,yw-fVelY,doorOpenType);
			scr_BreakBlock(xw-fVelX,yw-fVelY,blockDestroyType);
			if(!tileCollide)
			{
				scr_OpenDoor(xw,yw,doorOpenType);
				scr_BreakBlock(xw,yw,blockDestroyType);
			}
		}
			
		if(damage > 0)
		{
			if(hostile)
			{
				if(place_meeting(xw,yw,obj_Player))
	            {
	                player = instance_place(xw,yw,obj_Player);
	            }
			}
			else
			{
				scr_DamageNPC(xw,yw,damage,damageType,damageSubType,freezeType,deathType,immuneTime);
			}
		}
	}
}

if(damage > 0)
{
	if(hostile)
	{
		if(!instance_exists(player) && place_meeting(x,y,obj_Player))
		{
			player = instance_place(x,y,obj_Player);
		}
		if(instance_exists(player))
        {
            if (player.immuneTime <= 0 && !player.isScrewAttacking && !player.isSpeedBoosting)
            {
                //var ang = point_direction(x,y,obj_Player.x,obj_Player.y);
                var ang = 45;
                if(player.y > y)
                {
                    ang = 315;
                }
                if(player.x < x)
                {
                    ang = 135;
                    if(player.y > y)
                    {
                        ang = 225;
                    }
                }
                var knockX = lengthdir_x(knockBackSpeed,ang),
                    knockY = lengthdir_y(knockBackSpeed,ang);
                scr_DamagePlayer(damage,knockBack,knockX,knockY,damageImmuneTime);
                if(!multiHit)
                {
                    //instance_destroy();
					impacted = 1;
					damage = 0;
                }
            }
        }
	}
	else
	{
		scr_DamageNPC(x,y,damage,damageType,damageSubType,freezeType,deathType,immuneTime);
	}
}

for(var i = 0; i < array_length(npcImmuneTime); i++)
{
	npcImmuneTime[i]--;
}
#endregion

if(impacted > 0)
{
	if(impacted > 1)
	{
		instance_destroy();
	}
	impacted += 1;
}

if(!scr_WithinCamRange())
{
	instance_destroy();
}

#endregion

