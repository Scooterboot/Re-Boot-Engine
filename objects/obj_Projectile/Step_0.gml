/// @description Behavior

//#region Projectile Behavior

if(global.gamePaused)
{
	exit;
}

if(instance_exists(creator) && creator.object_index == obj_Player && lastReflec == noone)
{
	var hSpeed = creator.fVelX;
	if(sign(velX) == sign(hSpeed) && abs(speed_x) < abs(hSpeed))
	{
		speed_x = hSpeed;
	}
	var vSpeed = creator.fVelY * 0.75;
	if(sign(velY) == sign(vSpeed) && abs(speed_y) < abs(vSpeed))
	{
		speed_y = vSpeed;
	}
}

fVelX = velX + speed_x;
fVelY = velY + speed_y;

#region Reflection

var _x = x,
	_y = y;
if(aiStyle == 1 || aiStyle == 2)
{
	_x = xx;
	_y = yy;
}

var reflec = noone;
collision_line_list(_x,_y,_x+fVelX,_y+fVelY,obj_Reflec,true,true,reflecList,true);
if(tileCollide && doorOpenType >= 0)
{
	collision_line_list(_x,_y,_x+fVelX,_y+fVelY,obj_DoorHatch,true,true,reflecList,true);
}
for(var i = 0; i < ds_list_size(reflecList); i++)
{
	var _ref = reflecList[| i];
	if(instance_exists(_ref))
	{
		if(_ref.object_index == obj_Reflec)
		{
			var p1 = _ref.GetPoint1(),
				p2 = _ref.GetPoint2();
			if(lines_intersect(p1.X,p1.Y,p2.X,p2.Y,_x,_y,_x+fVelX,_y+fVelY,true) > 0 && lastReflec != _ref)
			{
				reflec = _ref;
				break;
			}
		}
		else if(_ref.object_index == obj_DoorHatch || object_is_ancestor(_ref.object_index,obj_DoorHatch))
		{
			if((!_ref.unlocked ||
			(doorOpenType <= -1 && _ref.object_index == obj_DoorHatch) ||
			(doorOpenType != 1 && doorOpenType != 2 && _ref.object_index == obj_DoorHatch_Missile) ||
			(doorOpenType != 2 && _ref.object_index == obj_DoorHatch_Super) ||
			(doorOpenType != 3 && _ref.object_index == obj_DoorHatch_Power)) && doorOpenType != 4)
			{
				reflec = _ref;
				break;
			}
		}
	}
}
ds_list_clear(reflecList);

if(instance_exists(reflec) && lastReflec != reflec)
{
	var _ang = direction;
	var _spd = point_distance(0,0,velX,velY);
	
	var vX = 0,
		vY = 0,
		_c = 0;
	if(reflec.object_index == obj_Reflec)
	{
		_ang = ReflectAngle(_ang, reflec.image_angle+90);
		
		var p1 = reflec.GetPoint1(),
			p2 = reflec.GetPoint2();
		while(lines_intersect(p1.X,p1.Y,p2.X,p2.Y,_x,_y,_x+vX,_y+vY,true) <= 0 && _c < _spd)
		{
			vX += sign(velX) * min(1,abs(velX)-abs(vX));
			vY += sign(velY) * min(1,abs(velY)-abs(vY));
			_c++;
		}
	}
	else if(reflec.object_index == obj_DoorHatch || object_is_ancestor(reflec.object_index,obj_DoorHatch))
	{
		_ang = ReflectAngle(_ang, reflec.image_angle+(180 * (reflec.image_xscale < 0)));
		
		while(!collision_line(_x,_y,_x+vX,_y+vY,reflec,true,true) && _c < _spd)
		{
			vX += sign(velX) * min(1,abs(velX)-abs(vX));
			vY += sign(velY) * min(1,abs(velY)-abs(vY));
			_c++;
		}
		vX -= sign(velX);
		vY -= sign(velY);
		_c--;
	}
	
	xstart = _x+vX;
	ystart = _y+vY;
	
	velX = lengthdir_x(_spd,_ang);
	velY = lengthdir_y(_spd,_ang);
	
	while(_c < _spd)
	{
		vX += sign(velX) * min(1,abs(velX)-abs(vX));
		vY += sign(velY) * min(1,abs(velY)-abs(vY));
		_c++;
	}
	
	fVelX = vX;
	fVelY = vY;
	
	direction = _ang;
	
	speed_x = 0;
	speed_y = 0;
	
	lastReflec = reflec;
}

#endregion

#region Collision
if(tileCollide && impacted == 0)
{
	//Collision_Normal(fVelX,fVelY,16,16,false,false);
	
	var fVX = fVelX,
		fVY = fVelY;
	
	var counter = abs(fVelX)+abs(fVelY);
	if(entity_position_collide(fVelX,fVelY,x,y) || entity_position_collide(0,0,x,y) || entity_collision_line(x-fVelX,y-fVelY,x+fVelX,y+fVelY,true,true))
	{
		while(!entity_position_collide(sign(fVelX),sign(fVelY),x,y) && !entity_position_collide(0,0,x,y) && !entity_collision_line(x-fVelX,y-fVelY,x+sign(fVelX),y+sign(fVelY),true,true) && counter > 0)
		{
			x += sign(fVelX);
			y += sign(fVelY);
			counter--;
		}
		speed_x = 0;
		speed_y = 0;
		fVX = 0;
		fVY = 0;
		
		impacted = 1;
	}
		
	x += fVX;
	y += fVY;
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

var deathType = npcDeathType,
    invFrames = 10;//4;

if(impacted > 0)
{
	TileInteract(x+fVelX,y+fVelY);
	TileInteract(x,y);
	TileInteract(x-fVelX,y-fVelY);
}
else
{
	TileInteract(x-fVelX,y-fVelY);
	if(!tileCollide)
	{
		TileInteract(x,y);
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
			TileInteract(xw+fVelX,yw+fVelY);
			TileInteract(xw,yw);
			TileInteract(xw-fVelX,yw-fVelY);
		}
		else
		{
			TileInteract(xw-fVelX,yw-fVelY);
			if(!tileCollide)
			{
				TileInteract(xw,yw);
			}
		}
			
		if(damage > 0 && dmgDelay <= 0)
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
				scr_DamageNPC(xw,yw,damage,damageType,damageSubType,freezeType,deathType,invFrames);
			}
		}
	}
}

if(dmgDelay <= 0)
{
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
				player.StrikePlayer(damage,knockBack,knockX,knockY,damageInvFrames)
				if(!multiHit)
				{
					//instance_destroy();
					impacted = 1;
					damage = 0;
				}
	        }
		}
		else
		{
			scr_DamageNPC(x,y,damage,damageType,damageSubType,freezeType,deathType,invFrames);
		}
	}
}
else
{
	dmgDelay--;
}

for(var i = 0; i < array_length(npcInvFrames); i++)
{
	npcInvFrames[i] = max(npcInvFrames[i]-1,0);
}
#endregion

if(impacted == 1)
{
	if(impactSnd != noone)
	{
		if(audio_is_playing(impactSnd))
		{
			audio_stop_sound(impactSnd);
		}
		audio_play_sound(impactSnd,0,false);
	}
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
	OnImpact();
}

if(impacted > 0)
{
	if(impacted > 1)
	{
		instance_destroy();
	}
	impacted += 1;
}

if(timeLeft > -1)
{
	if(timeLeft <= 0)
	{
		instance_destroy();
	}
	else
	{
		timeLeft--;
	}
}

if(!scr_WithinCamRange() && !ignoreCamera)
{
	instance_destroy();
}

//#endregion

