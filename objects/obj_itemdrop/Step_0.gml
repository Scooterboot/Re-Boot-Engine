/// @description 

if(global.gamePaused)
{
	exit;
}

var player = obj_Player;
if(instance_exists(player))
{
	var accel = 0.25;
	var frict = 0.5;
	var radius = 150;
	
	var grap = obj_GrappleBeamShot;
	if(instance_exists(grap))
	{
		var colLine = collision_line(player.x,player.y,grap.x,grap.y,self,true,false);
		if(place_meeting(x,y,grap) || colLine)
		{
			OnPlayerPickup();
			instance_destroy();
		}
	}
	
	if(place_meeting(x,y,player))
	{
		OnPlayerPickup();
		instance_destroy();
	}
	else if((player.statCharge >= 20 || (player.hyperBeam && player.cShoot)) && point_distance(x,y,player.x,player.y) < radius)
	{
		var mult = max((1 - (point_distance(x,y,player.x,player.y)/radius))*2,0.25);
		var mspeed = (player.statCharge/player.maxCharge) * 10 * mult,
			playerDir = point_direction(x,y,player.x,player.y);
		
		if(player.hyperBeam && player.cShoot)
		{
			mspeed = 10 * mult;
		}
		
		var xspeed = lengthdir_x(mspeed,playerDir),
			yspeed = lengthdir_y(mspeed,playerDir);
		
		accel *= mult;
		
		if(velX > xspeed)
		{
			velX = max(velX-accel,xspeed);
			if(velX > 0)
			{
				velX -= frict;
			}
		}
		else
		{
			velX = min(velX+accel,xspeed);
			if(velX < 0)
			{
				velX += frict;
			}
		}
		if(velY > yspeed)
		{
			velY = max(velY-accel,yspeed);
			if(velY > 0)
			{
				velY -= frict;
			}
		}
		else
		{
			velY = min(velY+accel,yspeed);
			if(velY < 0)
			{
				velY += frict;
			}
		}
	}
	else
	{
		if(velX > 0)
		{
			velX = max(velX-frict,0);
		}
		else
		{
			velX = min(velX+frict,0);
		}
		if(velY > 0)
		{
			velY = max(velY-frict,0);
		}
		else
		{
			velY = min(velY+frict,0);
		}
	}
}

x += velX;
y += velY;

frameCounter++;
if(frameCounter > frameCounterMax)
{
	frame = scr_wrap(frame+1,0,image_number);
	frameCounter = 0;
}

if(timeLeft < 0)
{
	instance_destroy();
}
timeLeft--;