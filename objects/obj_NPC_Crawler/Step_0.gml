/// @description AI Behavior
event_inherited();
if(PauseAI())
{
	exit;
}

var rot = rotation2;

var xcheck = 2,//max(abs(velX),2),
	ycheck = 2;//max(abs(velY),2);
var collideAny = (entity_place_collide(xcheck,0) || entity_place_collide(-xcheck,0) || entity_place_collide(0,ycheck) || entity_place_collide(0,-ycheck) ||
				entity_place_collide(xcheck,ycheck) || entity_place_collide(-xcheck,ycheck) || entity_place_collide(xcheck,-ycheck) || entity_place_collide(-xcheck,-ycheck));

if(instance_exists(obj_ScreenShaker) && obj_ScreenShaker.active && colEdge != Edge.Bottom && !entity_place_collide(0,ycheck))
{
	collideAny = false;
}

if(!collideAny)
{
	colEdge = Edge.None;
}

if(colEdge == Edge.None)
{
	/*if(abs(scr_wrap(rotation2,-180,180)) < 90)
	{
		rotation2 = scr_wrap(-90*moveDir,0,360);
	}*/
	
	velX = 0;
	velY += min(fGrav,max(fallSpeedMax-velY,0));
	
	/*if(collideAny)
	{
		if(entity_place_collide(0,ycheck))
		{
			colEdge = Edge.Bottom;
		}
		else if(entity_place_collide(0,-ycheck))
		{
			colEdge = Edge.Top;
		}
		else if(entity_place_collide(xcheck,0))
		{
			colEdge = Edge.Right;
		}
		else if(entity_place_collide(-xcheck,0))
		{
			colEdge = Edge.Left;
		}
	}*/
}

var colL = entity_collision_line(bb_left(),bb_top(),bb_left(),bb_bottom()),
	colR = entity_collision_line(bb_right(),bb_top(),bb_right(),bb_bottom()),
	colT = entity_collision_line(bb_left(),bb_top(),bb_right(),bb_top()),
	colB = entity_collision_line(bb_left(),bb_bottom(),bb_right(),bb_bottom());
if(entity_place_collide(0,0) && colL+colR+colT+colB >= 3)
{
	var flag3 = false;
	var dirX = 0, dirY = 0;
	if(!entity_collision_line(bb_right()+1,bb_top(),bb_right()+1,bb_bottom()))
	{
		dirX = 1;
	}
	else if(!entity_collision_line(bb_left()-1,bb_top(),bb_left()-1,bb_bottom()))
	{
		dirX = -1;
	}
	else
	{
		//dirX *= -1;
		flag3 = true;
	}
	
	if(!entity_collision_line(bb_left(),bb_bottom()+1,bb_right(),bb_bottom()+1))
	{
		dirY = 1;
	}
	else if(!entity_collision_line(bb_left(),bb_top()-1,bb_right(),bb_top()-1) || flag3)
	{
		dirY = -1;
	}
	else
	{
		//dirY *= -1;
	}
			
	velX = mSpeed*dirX;
	velY = mSpeed*dirY;
	position.X += velX;
	position.Y += velY;
	
	x = scr_round(position.X);
	y = scr_round(position.Y);
}
else
{
	switch(colEdge)
	{
		case Edge.Bottom:
		{
			velX = mSpeed*moveDir;
			velY = 1;
			break;
		}
		case Edge.Left:
		{
			velX = -1;
			velY = mSpeed*moveDir;
			break;
		}
		case Edge.Top:
		{
			velX = -mSpeed*moveDir;
			velY = -1;
			break;
		}
		case Edge.Right:
		{
			velX = 1;
			velY = -mSpeed*moveDir;
			break;
		}
	}
	
	if(colEdge != Edge.None)
	{
		rotation2 = GetEdgeAngle(colEdge);
	}
	
	fVelX = velX;
	fVelY = velY;
	Collision_Crawler(fVelX,fVelY,true);
}

var rot2 = scr_wrap(scr_round(rotation2),0,360);
rotation2 = scr_wrap(rot,0,360);
var rot3 = abs(rotation2 - rot2),
	rotRate = 10 * mSpeed;//radtodeg(0.25) * mSpeed;
if(rotation2 > rot2)
{
	if(rot3 > 180)
	{
		rotation2 += rotRate;
	}
	else
	{
		rotation2 = max(rotation2-rotRate,rot2);
	}
}
if(rotation2 < rot2)
{
	if(rot3 > 180)
	{
		rotation2 -= rotRate;
	}
	else
	{
		rotation2 = min(rotation2+rotRate,rot2);
	}
}
rotation = scr_round(rotation2/5.625)*5.625;
