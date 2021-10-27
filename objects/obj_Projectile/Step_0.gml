/// @description Behavior

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
	scr_OpenDoor(x,y,0);
	scr_BreakBlock(x,y,0);
	if(impact > 0)
	{
		scr_OpenDoor(x+sign(xspeed),y+sign(yspeed),0);
		scr_BreakBlock(x+sign(xspeed),y+sign(yspeed),0);
		scr_OpenDoor(x-xspeed,y-yspeed,0);
		scr_BreakBlock(x-xspeed,y-yspeed,0);
	}
	if(sprite_width > sprite_height)
	{
		var numw = abs(bbox_right - bbox_left),
		numd = clamp(abs(point_distance(x,y,xstart,ystart))/sprite_width,0,1);
		for(i = 0; i < max((sprite_width/numw)*numd,1); i++)
		{
			if(i > 0)
			{
				var xw = x-lengthdir_x(numw*i,direction),
					yw = y-lengthdir_y(numw*i,direction);
				scr_OpenDoor(xw,yw,0);
				scr_BreakBlock(xw,yw,0);
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

var freezeType = 0,
    deathType = -1,
    immuneTime = 4;

if(isIce)
{
    freezeType = 1 + isCharge;
}

if(!global.gamePaused && damage > 0)
{
    if(!hostile)
    {
        scr_DamageNPC(x,y,damage,damageType,freezeType,deathType,immuneTime);
        if(sprite_width > sprite_height)
        {
            var numw = abs(bbox_right - bbox_left),
                numd = clamp(abs(point_distance(x,y,xstart,ystart))/sprite_width,0,1);
            for(i = 0; i < max((sprite_width/numw)*numd,1); i++)
            {
                if(i > 0)
                {
                    var xw = x-lengthdir_x(numw*i,direction),
                        yw = y-lengthdir_y(numw*i,direction);
                    scr_DamageNPC(xw,yw,damage,damageType,freezeType,deathType,immuneTime);
                    //scr_DamageNPC(xw,yw,damage,damageType,freezeType,deathType,immuneTime);
                }
            }
        }
    }
    else
    {
        var player = instance_place(x,y,obj_Player);
        if(sprite_width > sprite_height)
        {
            var numw = abs(bbox_right - bbox_left),
                numd = clamp(abs(point_distance(x,y,xstart,ystart))/sprite_width,0,1);
            for(i = 0; i < max((sprite_width/numw)*numd,1); i++)
            {
                if(i > 0)
                {
                    var xw = x-lengthdir_x(numw*i,direction),
                        yw = y-lengthdir_y(numw*i,direction);
                    if(place_meeting(xw,yw,obj_Player))
                    {
                        player = instance_place(xw,yw,obj_Player);
                    }
                }
            }
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
}
#endregion