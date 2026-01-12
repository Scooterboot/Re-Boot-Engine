direction = 0;
speed = 0;

if(global.GamePaused())
{
    exit;
}

SetControlVars("player");

var player = creator;
if(!instance_exists(player))
{
	instance_destroy();
	exit;
}

var _dir = shootDir;
fVelX = lengthdir_x(velocity, _dir);
fVelY = lengthdir_y(velocity, _dir);

var _signX = lengthdir_x(1,_dir),
	_signY = lengthdir_y(1,_dir);

if(state == GravGrapState.None)
{
	if(impacted <= 0)
	{
		var _len = clamp(velocity, 10, point_distance(x,y,player.x,player.y));
		var _tailX = lengthdir_x(_len,_dir),
			_tailY = lengthdir_y(_len,_dir);
		if(self.entity_position_collide(fVelX,fVelY,x,y) || self.entity_collision_line(x-_tailX,y-_tailY,x+fVelX,y+fVelY,true,true))
		{
			var _vel = velocity;
			while(!self.entity_position_collide(_signX,_signY,x,y) && !self.entity_collision_line(x-_tailX,y-_tailY,x+_signX,y+_signY,true,true) && _vel >= 0)
			{
				x += _signX;
				y += _signY;
				_vel--;
			}
		
			state = GravGrapState.Ground;
		}
		else
		{
			x += fVelX;
			y += fVelY;
		}
		
		if(point_distance(x,y, player.x,player.y) > maxDist || !cFire)
		{
			impacted = 1;
		}
	}
	else if(impacted == 1)
	{
		_dir = point_direction(x,y, player.shootPosX,player.shootPosY);
		var _dist = min(velocity, point_distance(x,y, player.shootPosX,player.shootPosY));
		fVelX = lengthdir_x(_dist, _dir);
		fVelY = lengthdir_y(_dist, _dir);
		x += fVelX;
		y += fVelY;
		
		if(point_distance(x,y, player.shootPosX,player.shootPosY) <= _dist)
		{
			impacted = 2;
		}
	}
	else
	{
		instance_destroy();
	}
	
	//self.UpdatePoints();
}
else if(state == GravGrapState.Ground)
{
	/*self.UpdatePoints();
	player.velX += (normX - playerX)/250;
	player.velY += (normY - playerY)/250;
	player.frictMod *= 0.1;
	
	var spd = sqrt(player.velX*player.velX + player.velY*player.velY);
	if(spd > maxSpeed)
	{
		player.velX = (player.velX/spd)*maxSpeed;
		player.velY = (player.velY/spd)*maxSpeed;
	}
	player.velX *= speedDecay;
	player.velY *= speedDecay;*/
	
	if(!cFire)
	{
		instance_destroy();
	}
}

position.X = x;
position.Y = y;

SetReleaseVars("player");