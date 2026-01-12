/// @description Behavior

//#region Projectile Behavior

if(global.GamePaused())
{
	exit;
}

fVelX = velX + speed_x;
fVelY = velY + speed_y;

#region Reflection

var _x = x,
	_y = y;
if(projStyle == ProjStyle.Wave)
{
	_x = xx;
	_y = yy;
}

var reflec = noone;
var rnum = collision_line_list(_x,_y,_x+fVelX,_y+fVelY,obj_Reflec,true,true,reflecList,true);
if(tileCollide && array_contains(doorOpenType, true))
{
	rnum += collision_line_list(x,y,x+fVelX,y+fVelY,obj_DoorHatch,true,true,reflecList,true);
}
if(rnum > 0)
{
	for(var i = 0; i < rnum; i++)
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
			else if(object_is_ancestor(_ref.object_index,obj_DoorHatch))
			{
				if(!_ref.unlocked ||
				(!doorOpenType[DoorOpenType.Beam] && _ref.object_index == obj_DoorHatch_Blue) ||
				(!doorOpenType[DoorOpenType.Missile] && _ref.object_index == obj_DoorHatch_Missile) ||
				(!doorOpenType[DoorOpenType.SMissile] && _ref.object_index == obj_DoorHatch_Super) ||
				(!doorOpenType[DoorOpenType.PBomb] && _ref.object_index == obj_DoorHatch_Power))
				{
					reflec = _ref;
					break;
				}
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
	else if(object_is_ancestor(reflec.object_index,obj_DoorHatch))
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
	waveDir *= -1;
	if(projStyle == ProjStyle.Wave)
	{
		t = 0;
		t2 = 0;
	}
	
	speed_x = 0;
	speed_y = 0;
	
	lastReflec = reflec;
}

#endregion

#region Proj Styles

if(projStyle == ProjStyle.Wave || projStyle == ProjStyle.Spazer)
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
		if(projStyle == ProjStyle.Spazer)
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
		
		if(waveStyle >= 3 && projStyle == ProjStyle.Wave)
		{
			t2 = min(t2 + increment * (wavesPerSecond / 2) * (abs(i)-1), (pi / 2) * (abs(i)-1));
		}
	}
	i *= dir;
	i *= waveDir;
	shift = amplitude * sin(t - t2);
	
	var fVX = fVelX,
		fVY = fVelY;
	if(projStyle == ProjStyle.Wave)
	{
		var destX = xx + lengthdir_x(shift * i, direction + 90),
			destY = yy + lengthdir_y(shift * i, direction + 90);
		fVelX += destX - x;
		fVelY += destY - y;
	}
	else
	{
		fVelX += lengthdir_x((shift - prevShift) * i, direction + 90);
		fVelY += lengthdir_y((shift - prevShift) * i, direction + 90);
	}
	if(impacted == 0)
	{
		xx += fVX;
		yy += fVY;
	}
	
	prevShift = shift;
}
#endregion

#region Collision
if(tileCollide && impacted == 0)
{
	var velocity = point_distance(0,0,fVelX,fVelY);
	
	var _len = max(10,velocity);
	if(instance_exists(creator) && lastReflec == noone)
	{
		_len = min(_len, point_distance(x,y,creator.x,creator.y));
	}
	var _tailX = lengthdir_x(_len,direction),
		_tailY = lengthdir_y(_len,direction);
	
	var _dir = point_direction(0,0,fVelX,fVelY);
	var _signX = lengthdir_x(1,_dir),
		_signY = lengthdir_y(1,_dir);
	
	if(self.entity_position_collide(fVelX,fVelY,x,y) || self.entity_collision_line(x-_tailX,y-_tailY,x+fVelX,y+fVelY,true,true))
	{
		while(!self.entity_position_collide(_signX,_signY,x,y) && !self.entity_collision_line(x-_tailX,y-_tailY,x+_signX,y+_signY,true,true) && velocity >= 0)
		{
			x += _signX;
			y += _signY;
			velocity--;
		}
		
		impacted = 1;
	}
	else
	{
		x += fVelX;
		y += fVelY;
	}
	
	if(x < 0 || x > room_width || y < 0 || y > room_height)
	{
		x = clamp(x,0,room_width);
		y = clamp(y,0,room_height);
		impacted = 1;
	}
}
else if(impacted == 0)
{
	x += fVelX;
	y += fVelY;
}

position.X = x;
position.Y = y;
#endregion

#region Damage to enemies & tiles

if(impacted > 0)
{
	self.TileInteract(x+fVelX,y+fVelY);
	self.TileInteract(x,y);
	self.TileInteract(x-fVelX,y-fVelY);
}
else
{
	self.TileInteract(x-fVelX,y-fVelY);
	if(!tileCollide)
	{
		self.TileInteract(x,y);
	}
}

if(projLength > 0)
{
	var numw = max(abs(bb_right(0) - bb_left(0)),1),
        numd = clamp(point_distance(x,y,xstart,ystart),1,projLength);
	for(var j = numw; j < numd; j += numw)
	{
		var xw = x-lengthdir_x(j,direction),
			yw = y-lengthdir_y(j,direction);
		if(impacted > 0)
		{
			self.TileInteract(xw+fVelX,yw+fVelY);
			self.TileInteract(xw,yw);
			self.TileInteract(xw-fVelX,yw-fVelY);
		}
		else
		{
			self.TileInteract(xw-fVelX,yw-fVelY);
			if(!tileCollide)
			{
				self.TileInteract(xw,yw);
			}
		}
	}
}

if(dmgDelay <= 0)
{
	self.DamageBoxes();
}
else
{
	dmgDelay--;
}

self.IncrInvFrames();

#endregion

if(impacted == 1 && !reflected)
{
	self.OnImpact(x,y,dmgImpacted);
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

var _camFlag = ignoreCamera;
if(x < 0 || x > room_width || y < 0 || y > room_height)
{
	_camFlag = false;
}
if(!scr_WithinCamRange(-1,-1,extCamRange) && !_camFlag)
{
	outsideCam++;
	if(outsideCam > 1)
	{
		instance_destroy();
	}
}

//#endregion

