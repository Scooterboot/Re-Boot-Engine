/// @description AI Behavior
event_inherited();
if(self.PauseAI())
{
	exit;
}

var rot = rotation2;

var xcheck = 2,//max(abs(velX),2),
	ycheck = 2;//max(abs(velY),2);
var collideAny = (self.entity_place_collide(xcheck,0) || self.entity_place_collide(-xcheck,0) || self.entity_place_collide(0,ycheck) || self.entity_place_collide(0,-ycheck) ||
				self.entity_place_collide(xcheck,ycheck) || self.entity_place_collide(-xcheck,ycheck) || self.entity_place_collide(xcheck,-ycheck) || self.entity_place_collide(-xcheck,-ycheck));

if(instance_exists(obj_ScreenShaker) && obj_ScreenShaker.active && colEdge != Edge.Bottom && !self.entity_place_collide(0,ycheck))
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
		if(self.entity_place_collide(0,ycheck))
		{
			colEdge = Edge.Bottom;
		}
		else if(self.entity_place_collide(0,-ycheck))
		{
			colEdge = Edge.Top;
		}
		else if(self.entity_place_collide(xcheck,0))
		{
			colEdge = Edge.Right;
		}
		else if(self.entity_place_collide(-xcheck,0))
		{
			colEdge = Edge.Left;
		}
	}*/
}

var colL = self.entity_collision_line(self.bb_left(),self.bb_top(),self.bb_left(),self.bb_bottom()),
	colR = self.entity_collision_line(self.bb_right(),self.bb_top(),self.bb_right(),self.bb_bottom()),
	colT = self.entity_collision_line(self.bb_left(),self.bb_top(),self.bb_right(),self.bb_top()),
	colB = self.entity_collision_line(self.bb_left(),self.bb_bottom(),self.bb_right(),self.bb_bottom());
if(self.entity_place_collide(0,0) && colL+colR+colT+colB >= 3)
{
	var flag3 = false;
	var dirX = 0, dirY = 0;
	if(!self.entity_collision_line(self.bb_right()+1,self.bb_top(),self.bb_right()+1,self.bb_bottom()))
	{
		dirX = 1;
	}
	else if(!self.entity_collision_line(self.bb_left()-1,self.bb_top(),self.bb_left()-1,self.bb_bottom()))
	{
		dirX = -1;
	}
	else
	{
		//dirX *= -1;
		flag3 = true;
	}
	
	if(!self.entity_collision_line(self.bb_left(),self.bb_bottom()+1,self.bb_right(),self.bb_bottom()+1))
	{
		dirY = 1;
	}
	else if(!self.entity_collision_line(self.bb_left(),self.bb_top()-1,self.bb_right(),self.bb_top()-1) || flag3)
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
		rotation2 = self.GetEdgeAngle(colEdge);
	}
	
	fVelX = velX;
	fVelY = velY;
	self.Collision_Crawler(fVelX,fVelY,true);
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
