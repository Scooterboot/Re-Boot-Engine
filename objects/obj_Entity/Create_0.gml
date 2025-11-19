/// @description Initialize

position = new Vector2(x,y);
oldPosition = new Vector2(position.X,position.Y);

#region BBox vars
function bb_left(xx = undefined)
{
	/// @description bb_left
	/// @param baseX=position.X
	xx = is_undefined(xx) ? position.X : xx;
	return bbox_left-x + xx;
}
function bb_right(xx = undefined)
{
	/// @description bb_right
	/// @param baseX=position.X
	xx = is_undefined(xx) ? position.X : xx;
	return bbox_right-x + xx - 1;
}
function bb_top(yy = undefined)
{
	/// @description bb_top
	/// @param baseY=position.Y
	yy = is_undefined(yy) ? position.Y : yy;
	return bbox_top-y + yy;
}
function bb_bottom(yy = undefined)
{
	/// @description bb_bottom
	/// @param baseY=position.Y
	yy = is_undefined(yy) ? position.Y : yy;
	return bbox_bottom-y + yy - 1;
}
#endregion

function Center(useRealXY = false)
{
	if(useRealXY)
	{
		return new Vector2(self.bb_left(x) + (self.bb_right(x)-self.bb_left(x))/2, self.bb_top(y) + (self.bb_bottom(y)-self.bb_top(y))/2);
	}
	return new Vector2(self.bb_left() + (self.bb_right()-self.bb_left())/2, self.bb_top() + (self.bb_bottom()-self.bb_top())/2);
}

velX = 0; // velocity x
velY = 0; // velocity y
fVelX = 0; // final velocity x
fVelY = 0; // final velocity y
shiftX = 0;
shiftY = 0;
movedVelX = 0;
movedVelY = 0;

enum Edge
{
	None,
	Bottom,
	Top,
	Right,
	Left
};
colEdge = Edge.Bottom;

grounded = false;

solids = array_concat(ColType_Solid, ColType_MovingSolid);

function CanPlatformCollide()
{
	return false;
}

blockList = ds_list_create();

#region Base Collision Checks

function entity_place_collide(offsetX, offsetY, xx = undefined, yy = undefined)
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	xx = is_undefined(xx) ? position.X : xx;
	yy = is_undefined(yy) ? position.Y : yy;
	
	if(self.CanPlatformCollide() && place_meeting(xx+offsetX,yy+offsetY,ColType_Platform))
	{
		if(self.entityPlatformCheck(offsetX,offsetY,xx,yy))
		{
			return true;
		}
	}
	
	return self.entity_collision(instance_place_list(xx+offsetX,yy+offsetY,solids,blockList,true));
}

function entity_position_collide(offsetX, offsetY, xx = undefined, yy = undefined)
{
	/// @description entity_position_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	xx = is_undefined(xx) ? position.X : xx;
	yy = is_undefined(yy) ? position.Y : yy;
	
	return self.entity_collision(instance_position_list(xx+offsetX,yy+offsetY,solids,blockList,true));
}

function entity_collision_line(x1,y1,x2,y2, prec = true, notme = true)
{
	return self.entity_collision(collision_line_list(x1,y1,x2,y2,solids,prec,notme,blockList,true));
}
function entity_collision_rectangle(x1,y1,x2,y2, prec = true, notme = true)
{
	return self.entity_collision(collision_rectangle_list(x1,y1,x2,y2,solids,prec,notme,blockList,true));
}

function entity_collision(listNum)
{
	if(listNum > 0)
	{
		for(var i = 0; i < listNum; i++)
		{
			if(instance_exists(blockList[| i]))
			{
				var block = blockList[| i];
				var isSolid = true;
				if(block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
				{
					isSolid = block.isSolid;
					if(block.ignoredEntity == id || block.tempIgnoredEnt == id)
					{
						isSolid = false;
					}
				}
				if(isSolid)
				{
					ds_list_clear(blockList);
					return true;
				}
			}
		}
		ds_list_clear(blockList);
	}
	return false;
}

function entityPlatformCheck(offsetX, offsetY, xx = undefined, yy = undefined)
{
	/// @description entityPlatformCheck
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	xx = is_undefined(xx) ? position.X : xx;
	yy = is_undefined(yy) ? position.Y : yy;
	
	if(place_meeting(xx+offsetX,yy+offsetY,ColType_Platform))
	{
		var pl = instance_place_list(xx+offsetX,yy+offsetY,ColType_Platform,blockList,true);
		for(var i = 0; i < pl; i++)
		{
			if(instance_exists(blockList[| i]))
			{
				var platform = blockList[| i];
				if(platform.isSolid && place_meeting(xx+offsetX,yy+offsetY,platform) && !place_meeting(xx,yy,platform) && self.bb_bottom(yy) < platform.bbox_top)
				{
					ds_list_clear(blockList);
					return true;
				}
			}
		}
		ds_list_clear(blockList);
	}
	return false;
}

// Simple place_meeting shortcut for use in optimizing certain parts of collision code.
// (Though it is currently only used in GetEdgeAngle atm.)
function entity_place_meeting(offsetX, offsetY, xx = undefined, yy = undefined)
{
	/// @description entity_place_meeting
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	xx = is_undefined(xx) ? position.X : xx;
	yy = is_undefined(yy) ? position.Y : yy;
	
	return place_meeting(xx+offsetX,yy+offsetY,solids);
}

#endregion
#region GetEdgeAngle

function GetEdgeAngle(edge, offsetX = 0, offsetY = 0)
{
	var pos1 = new Vector2(0,0),
		pos2 = new Vector2(0,0);
	
	var ang = 0;
	if(edge == Edge.Right)
	{
		ang = 90;
	}
	if(edge == Edge.Top)
	{
		ang = 180;
	}
	if(edge == Edge.Left)
	{
		ang = -90;//270;
	}
	
	var maxX = 4,
		maxY = 4;
	
	if(edge == Edge.Bottom || edge == Edge.Top)
	{
		var ySign = 1;
		if(edge == Edge.Top)
		{
			ySign = -1;
		}
		
		if(self.entity_place_collide(offsetX,offsetY+ySign) || ((self.entity_place_collide(offsetX+1,offsetY) ^^ self.entity_place_collide(offsetX-1,offsetY)) && self.entity_place_collide(offsetX,offsetY+ySign*maxY)))
		{
			//while(!self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.Y) < maxY)
			while(!self.entity_place_meeting(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.Y) < maxY)
			{
				pos1.Y += ySign;
			}
			if(abs(pos1.Y) >= maxY)
			{
				return ang;
			}
			pos2.Y = pos1.Y;
			
			//while(!self.entity_place_collide(pos1.X-1+offsetX,pos1.Y+offsetY) && self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.X) < maxX)
			while(!self.entity_place_meeting(pos1.X-1+offsetX,pos1.Y+offsetY) && self.entity_place_meeting(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.X) < maxX)
			{
				pos1.X -= 1;
			}
			//while(!self.entity_place_collide(pos2.X+1+offsetX,pos2.Y+offsetY) && self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY) && abs(pos2.X) < maxX)
			while(!self.entity_place_meeting(pos2.X+1+offsetX,pos2.Y+offsetY) && self.entity_place_meeting(pos2.X+offsetX,pos2.Y+ySign+offsetY) && abs(pos2.X) < maxX)
			{
				pos2.X += 1;
			}
			if(abs(pos1.X) >= maxX || abs(pos2.X) >= maxX)
			{
				return ang;
			}
			
			var checkDir = 0;
			if(!self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) || self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY))
			{
				checkDir = 1;
			}
			if(self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) || !self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY))
			{
				checkDir = -1;
			}
			
			if(checkDir == 1)
			{
				//while(!self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.Y) < maxY)
				while(!self.entity_place_meeting(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.Y) < maxY)
				{
					pos1.Y += ySign;
				}
				//while(self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && abs(pos2.Y) < maxY)
				while(self.entity_place_meeting(pos2.X+offsetX,pos2.Y+offsetY) && abs(pos2.Y) < maxY)
				{
					pos2.Y -= ySign;
				}
			}
			if(checkDir == -1)
			{
				//while(self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && abs(pos1.Y) < maxY)
				while(self.entity_place_meeting(pos1.X+offsetX,pos1.Y+offsetY) && abs(pos1.Y) < maxY)
				{
					pos1.Y -= ySign;
				}
				//while(!self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY) && abs(pos2.Y) < maxY)
				while(!self.entity_place_meeting(pos2.X+offsetX,pos2.Y+ySign+offsetY) && abs(pos2.Y) < maxY)
				{
					pos2.Y += ySign;
				}
			}
			if(abs(pos1.Y) >= maxY || abs(pos2.Y) >= maxY || checkDir == 0)
			{
				return ang;
			}
			
			//if(checkDir != 0 && pos1.Y != pos2.Y && 
			//!self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && 
			//!self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY))
			if(checkDir != 0 && pos1.Y != pos2.Y && 
			!self.entity_place_meeting(pos1.X+offsetX,pos1.Y+offsetY) && self.entity_place_meeting(pos1.X+offsetX,pos1.Y+ySign+offsetY) && 
			!self.entity_place_meeting(pos2.X+offsetX,pos2.Y+offsetY) && self.entity_place_meeting(pos2.X+offsetX,pos2.Y+ySign+offsetY))
			{
				var poses = array_create(2);
				poses[0] = pos1;
				poses[1] = pos2;
				if(pos1.X > pos2.X)
				{
					poses[0] = pos2;
					poses[1] = pos1;
				}
				if(edge == Edge.Top)
				{
					poses[0] = pos2;
					poses[1] = pos1;
					if(pos1.X > pos2.X)
					{
						poses[0] = pos1;
						poses[1] = pos2;
					}
				}
				ang += angle_difference(point_direction(poses[0].X,poses[0].Y,poses[1].X,poses[1].Y),ang);
			}
		}
	}
	
	if(edge == Edge.Right || edge == Edge.Left)
	{
		var xSign = 1;
		if(edge == Edge.Left)
		{
			xSign = -1;
		}
		
		if(self.entity_place_collide(offsetX+xSign,offsetY) || ((self.entity_place_collide(offsetX,offsetY+1) ^^ self.entity_place_collide(offsetX,offsetY-1)) && self.entity_place_collide(offsetX+xSign*maxX,offsetY)))
		{
			//while(!self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
			while(!self.entity_place_meeting(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
			{
				pos1.X += xSign;
			}
			if(abs(pos1.X) >= maxX)
			{
				return ang;
			}
			pos2.X = pos1.X;
			
			//while(!self.entity_place_collide(pos1.X+offsetX,pos1.Y-1+offsetY) && self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.Y) < maxY)
			while(!self.entity_place_meeting(pos1.X+offsetX,pos1.Y-1+offsetY) && self.entity_place_meeting(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.Y) < maxY)
			{
				pos1.Y -= 1;
			}
			//while(!self.entity_place_collide(pos2.X+offsetX,pos2.Y+1+offsetY) && self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY) && abs(pos2.Y) < maxY)
			while(!self.entity_place_meeting(pos2.X+offsetX,pos2.Y+1+offsetY) && self.entity_place_meeting(pos2.X+xSign+offsetX,pos2.Y+offsetY) && abs(pos2.Y) < maxY)
			{
				pos2.Y += 1;
			}
			if(abs(pos1.Y) >= maxY || abs(pos2.Y) >= maxY)
			{
				return ang;
			}
			
			var checkDir = 0;
			if(!self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) || self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY))
			{
				checkDir = 1;
			}
			if(self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) || !self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY))
			{
				checkDir = -1;
			}
			
			if(checkDir == 1)
			{
				//while(!self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
				while(!self.entity_place_meeting(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
				{
					pos1.X += xSign;
				}
				//while(self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && abs(pos2.X) < maxX)
				while(self.entity_place_meeting(pos2.X+offsetX,pos2.Y+offsetY) && abs(pos2.X) < maxX)
				{
					pos2.X -= xSign;
				}
			}
			if(checkDir == -1)
			{
				//while(self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
				while(self.entity_place_meeting(pos1.X+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
				{
					pos1.X -= xSign;
				}
				//while(!self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY) && abs(pos2.X) < maxX)
				while(!self.entity_place_meeting(pos2.X+xSign+offsetX,pos2.Y+offsetY) && abs(pos2.X) < maxX)
				{
					pos2.X += xSign;
				}
			}
			if(abs(pos1.X) >= maxX || abs(pos2.X) >= maxX || checkDir == 0)
			{
				return ang;
			}
			
			//if(checkDir != 0 && pos1.X != pos2.X && 
			//!self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && 
			//!self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY))
			if(checkDir != 0 && pos1.X != pos2.X && 
			!self.entity_place_meeting(pos1.X+offsetX,pos1.Y+offsetY) && self.entity_place_meeting(pos1.X+xSign+offsetX,pos1.Y+offsetY) && 
			!self.entity_place_meeting(pos2.X+offsetX,pos2.Y+offsetY) && self.entity_place_meeting(pos2.X+xSign+offsetX,pos2.Y+offsetY))
			{
				var poses = array_create(2);
				poses[0] = pos1;
				poses[1] = pos2;
				if(pos1.Y < pos2.Y)
				{
					poses[0] = pos2;
					poses[1] = pos1;
				}
				if(edge == Edge.Left)
				{
					poses[0] = pos2;
					poses[1] = pos1;
					if(pos1.Y < pos2.Y)
					{
						poses[0] = pos1;
						poses[1] = pos2;
					}
				}
				ang += angle_difference(point_direction(poses[0].X,poses[0].Y,poses[1].X,poses[1].Y),ang);
			}
		}
	}
	
	return angle_difference(ang,0);
}
#endregion

#region Collision Hooks

function ModifyFinalVelX(fVX) { return fVX; }
function ModifyFinalVelY(fVY) { return fVY; }

function ModifySlopeXSteepness_Up() { return 1; }
function ModifySlopeXSteepness_Down() { return 1; }
function ModifySlopeYSteepness_Up() { return 0.5; }
function ModifySlopeYSteepness_Down() { return 0.5; }

// called on horizontal collision
function OnRightCollision(fVX) {} // -->|
function OnLeftCollision(fVX) {} // |<--
function OnXCollision(fVX, isOOB = false) {} // same as both above

// check if allowed to move "up" a slope while on the floor, like so:
//	  ->/
//	 - /
//	- /
function CanMoveUpSlope_Bottom() { return true; }
function OnSlopeXCollision_Bottom(fVX, yShift) {} // -->/

// check if allowed to move "down" a slope while on the floor, like so:
//	\ -
//	 \ -
//	  \ ->
function CanMoveDownSlope_Bottom() { return true; }

// check if allowed to move "up" a slope while on the ceiling, like so:
//	- \
//	 - \
//	  ->\
function CanMoveUpSlope_Top() { return false; }
function OnSlopeXCollision_Top(fVX, yShift) {} // -->\

// check if allowed to move "down" a slope while on the ceiling, like so:
//	  / ->
//	 / -
//	/ -
function CanMoveDownSlope_Top() { return false; }


// called on vertical collision
function OnBottomCollision(fVY) {}
function OnTopCollision(fVY) {}
function OnYCollision(fVY, isOOB = false) {} // same as both above

// check if allowed to move "up" a slope on the right wall, like so:
//	^ \
//	 | \
//	  | \
function CanMoveUpSlope_Right() { return false; }
function OnSlopeYCollision_Right(fVY, xShift) {}

// check if allowed to move "down" a slope on the right wall, like so:
//	  ^ /
//	 | /
//	| /
function CanMoveDownSlope_Right() { return false; }

// check if allowed to move "up" a slope on the left wall, like so:
//	  / ^
//	 / |
//	/ |
function CanMoveUpSlope_Left() { return false; }
function OnSlopeYCollision_Left(fVY, xShift) {}

// check if allowed to move "down" a slope on the left wall, like so:
//	\ ^
//	 \ |
//	  \ |
function CanMoveDownSlope_Left() { return false; }

//function OnPlatformCollision(fVY) {}

function DestroyBlock(bx,by) {}

#endregion
#region Collision_Normal
function Collision_Normal(vX, vY, slopeSpeedAdjust, ignoreOOB = false)
{
	oldPosition.Equals(position);
	
	if(slopeSpeedAdjust)
	{
		var sAngle = 0;
		var _btm = self.entity_place_collide(0,2), _top = self.entity_place_collide(0,-2);
		if(_btm && !_top)
		{
			sAngle = self.GetEdgeAngle(Edge.Bottom);
		}
		if(_top && !_btm)
		{
			sAngle = angle_difference(self.GetEdgeAngle(Edge.Top),180);
		}
		vX = lengthdir_x(vX,sAngle);
		
		sAngle = 0;
		var _rgt = self.entity_place_collide(2,0), _lft = self.entity_place_collide(-2,0);
		if(_rgt && !_lft)
		{
			sAngle = angle_difference(self.GetEdgeAngle(Edge.Right),90);
		}
		if(_lft && !_rgt)
		{
			sAngle = angle_difference(self.GetEdgeAngle(Edge.Left),270);
		}
		vY = lengthdir_x(vY,sAngle);
	}
	
	vX += shiftX;
	vY += shiftY;
	
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while(maxSpeedX > 0 || maxSpeedY > 0)
	{
		var fVX = self.ModifyFinalVelX(min(maxSpeedX,1)*sign(vX));
		if(fVX != 0)
		{
			#region X Collision
		
			self.DestroyBlock(position.X+fVX,position.Y);
			
			var colClip = self.entity_place_collide(0,0);
			var colR = self.entity_collision_line(self.bb_right()+fVX,self.bb_top(),self.bb_right()+fVX,self.bb_bottom()),
				colL = self.entity_collision_line(self.bb_left()+fVX,self.bb_top(),self.bb_left()+fVX,self.bb_bottom());
			if(self.entity_place_collide(sign(fVX),0) && (!colClip || (fVX > 0 && colR) || (fVX < 0 && colL)))
			{
				var steepness = self.ModifySlopeXSteepness_Up();
				var xnum = sign(fVX);
				if(steepness < 1)
				{
					xnum = scr_round(1/steepness) * sign(fVX);
					steepness = 1;
				}
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveUpSlope_Bottom = (self.CanMoveUpSlope_Bottom() && !self.entity_place_collide(xnum,-steepness) && self.entity_place_collide(0,steepness));
				var moveUpSlope_Top = (self.CanMoveUpSlope_Top() && !self.entity_place_collide(xnum,steepness) && self.entity_place_collide(0,-steepness));
			
				var yplus = 0;
				if(moveUpSlope_Bottom)
				{
					while(self.entity_place_collide(fVX,yplus) && yplus > -steepness)
					{
						yplus--;
					}
				}
				if(moveUpSlope_Top)
				{
					while(self.entity_place_collide(fVX,yplus) && yplus < steepness)
					{
						yplus++;
					}
				}
			
				if(self.entity_place_collide(fVX,yplus) || (!moveUpSlope_Bottom && !moveUpSlope_Top))
				{
					if(fVX > 0)
					{
						position.X = scr_floor(position.X);
					}
					if(fVX < 0)
					{
						position.X = scr_ceil(position.X);
					}
					if(!self.entity_place_collide(sign(fVX),0))
					{
						position.X += sign(fVX);
					}
					
					if(fVX > 0)
					{
						self.OnRightCollision(fVX);
					}
					if(fVX < 0)
					{
						self.OnLeftCollision(fVX);
					}
					self.OnXCollision(fVX);
					fVX = 0;
					maxSpeedX = 0;
				}
				else
				{
					if(yplus > 0)
					{
						self.OnSlopeXCollision_Top(fVX,yplus);
						position.Y = floor(position.Y + yplus);
						if(self.entity_place_collide(fVX,0))
						{
							position.Y += 1;
						}
					}
					else
					{
						self.OnSlopeXCollision_Bottom(fVX,yplus);
						position.Y = ceil(position.Y + yplus);
						if(self.entity_place_collide(fVX,0))
						{
							position.Y -= 1;
						}
					}
				}
			}
			else if(!colClip)
			{
				var steepness = self.ModifySlopeXSteepness_Down();
				var xnum = sign(fVX);
				if(steepness < 1)
				{
					xnum = scr_round(1/steepness) * sign(fVX);
					steepness = 1;
				}
				steepness += 1;
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveDownSlope_Bottom = (self.CanMoveDownSlope_Bottom() && self.entity_place_collide(0,1) && self.entity_place_collide(xnum,steepness));
				var moveDownSlope_Top = (self.CanMoveDownSlope_Top() && self.entity_place_collide(0,-1) && self.entity_place_collide(xnum,-steepness));
			
				if(moveDownSlope_Bottom || moveDownSlope_Top)
				{
					var yplus2 = 0;
					if(moveDownSlope_Bottom)
					{
						while(!self.entity_place_collide(fVX,yplus2+1) && yplus2 < steepness)
						{
							yplus2++;
						}
					}
					if(moveDownSlope_Top)
					{
						while(!self.entity_place_collide(fVX,yplus2-1) && yplus2 > -steepness)
						{
							yplus2--;
						}
					}
				
					if(!self.entity_place_collide(fVX,yplus2))
					{
						if(self.entity_place_collide(fVX,yplus2+sign(yplus2)))
						{
							if(yplus2 > 0)
							{
								position.Y = ceil(position.Y + yplus2);
								if(self.entity_place_collide(fVX,0))
								{
									position.Y -= 1;
								}
							}
							else
							{
								position.Y = floor(position.Y + yplus2);
								if(self.entity_place_collide(fVX,0))
								{
									position.Y += 1;
								}
							}
						}
					}
				}
			}
			#endregion
			
			position.X += fVX;
		}
		if(!ignoreOOB && (position.X > room_width || position.X < 0))
		{
			if(position.X > room_width)
			{
				self.OnRightCollision(fVX);
			}
			if(position.X < 0)
			{
				self.OnLeftCollision(fVX);
			}
			self.OnXCollision(fVX, true);
			position.X = clamp(position.X,0,room_width);
		}
		x = scr_round(position.X);
		
		var fVY = self.ModifyFinalVelY(min(maxSpeedY,1)*sign(vY));
		if(fVY != 0)
		{
			#region Y Collision
		
			self.DestroyBlock(position.X,position.Y+fVY);
		
			var colClip = self.entity_place_collide(0,0);
			var colB = self.entity_collision_line(self.bb_left(),self.bb_bottom()+fVY,self.bb_right(),self.bb_bottom()+fVY),
				colT = self.entity_collision_line(self.bb_left(),self.bb_top()+fVY,self.bb_right(),self.bb_top()+fVY);
			if(self.entity_place_collide(0,sign(fVY)) && (!colClip || (fVY > 0 && colB) || (fVY < 0 && colT)))
			{
				var steepness = self.ModifySlopeYSteepness_Up();
				var ynum = sign(fVY);
				if(steepness < 1)
				{
					ynum = scr_round(1/steepness) * sign(fVY);
					steepness = 1;
				}
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveUpSlope_Right = (self.CanMoveUpSlope_Right() && !self.entity_place_collide(-steepness,ynum) && self.entity_place_collide(steepness,0));
				var moveUpSlope_Left = (self.CanMoveUpSlope_Left() && !self.entity_place_collide(steepness,ynum) && self.entity_place_collide(-steepness,0));
			
				var xplus = 0;
				if(moveUpSlope_Right)
				{
					while(self.entity_place_collide(xplus,fVY) && xplus > -steepness)
					{
						xplus--;
					}
				}
				if(moveUpSlope_Left)
				{
					while(self.entity_place_collide(xplus,fVY) && xplus < steepness)
					{
						xplus++;
					}
				}
			
				if(self.entity_place_collide(xplus,fVY) || (!moveUpSlope_Right && !moveUpSlope_Left))
				{
					if(fVY > 0)
					{
						position.Y = scr_floor(position.Y);
					}
					if(fVY < 0)
					{
						position.Y = scr_ceil(position.Y);
					}
					if(!self.entity_place_collide(0,sign(fVY)))
					{
						position.Y += sign(fVY);
					}
					
					if(fVY > 0)
					{
						self.OnBottomCollision(fVY);
					}
					if(fVY < 0)
					{
						self.OnTopCollision(fVY);
					}
					self.OnYCollision(fVY);
					fVY = 0;
					maxSpeedY = 0;
				}
				else
				{
					if(xplus > 0)
					{
						self.OnSlopeYCollision_Left(fVY,xplus);
						position.X = floor(position.X + xplus);
						if(self.entity_place_collide(0,fVY))
						{
							position.X += 1;
						}
					}
					else
					{
						self.OnSlopeYCollision_Right(fVY,xplus);
						position.X = ceil(position.X + xplus);
						if(self.entity_place_collide(0,fVY))
						{
							position.X -= 1;
						}
					}
				}
			}
			else if(!colClip)
			{
				var steepness = self.ModifySlopeYSteepness_Down();
				var ynum = sign(fVY);
				if(steepness < 1)
				{
					ynum = scr_round(1/steepness) * sign(fVY);
					steepness = 1;
				}
				steepness += 1;
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveDownSlope_Right = (self.CanMoveDownSlope_Right() && self.entity_place_collide(1,0) && self.entity_place_collide(steepness,ynum));
				var moveDownSlope_Left = (self.CanMoveDownSlope_Left() && self.entity_place_collide(-1,0) && self.entity_place_collide(-steepness,ynum));
			
				if(moveDownSlope_Right || moveDownSlope_Left)
				{
					var xplus2 = 0;
					if(moveDownSlope_Right)
					{
						while(!self.entity_place_collide(1+xplus2,fVY) && xplus2 < steepness)
						{
							xplus2++;
						}
					}
					if(moveDownSlope_Left)
					{
						while(!self.entity_place_collide(-1+xplus2,fVY) && xplus2 > -steepness)
						{
							xplus2--;
						}
					}
				
					if(!self.entity_place_collide(xplus2,fVY))
					{
						if(self.entity_place_collide(xplus2+sign(xplus2),fVY))
						{
							if(xplus2 > 0)
							{
								position.X = ceil(position.X + xplus2);
								if(self.entity_place_collide(0,fVY))
								{
									position.X -= 1;
								}
							}
							else
							{
								position.X = floor(position.X + xplus2);
								if(self.entity_place_collide(0,fVY))
								{
									position.X += 1;
								}
							}
						}
					}
				}
			}
		
			#endregion
			
			position.Y += fVY;
		}
		if(!ignoreOOB && (position.Y > room_height || position.Y < 0))
		{
			if(position.Y > room_height)
			{
				self.OnBottomCollision(fVX);
			}
			if(position.Y < 0)
			{
				self.OnTopCollision(fVX);
			}
			self.OnYCollision(fVX, true);
			position.Y = clamp(position.Y,0,room_height);
		}
		y = scr_round(position.Y);
		
		maxSpeedX = max(maxSpeedX-1,0);
		maxSpeedY = max(maxSpeedY-1,0);
	}
	
	shiftX = 0;
	shiftY = 0;
	
	movedVelX = 0;
	movedVelY = 0;
}
#endregion

#region Crawler Collision Hooks

function Crawler_ModifyFinalVelX(fVX) { return fVX; }
function Crawler_ModifyFinalVelY(fVY) { return fVY; }

function Crawler_CanStickRight() { return true; }
function Crawler_CanStickLeft() { return true; }
function Crawler_CanStickOuterRight() { return (colEdge != Edge.None); }
function Crawler_CanStickOuterLeft() { return (colEdge != Edge.None); }

function Crawler_CanStickBottom() { return true; }
function Crawler_CanStickTop() { return true; }
function Crawler_CanStickOuterBottom() { return (colEdge != Edge.None); }
function Crawler_CanStickOuterTop() { return (colEdge != Edge.None); }


// called on horizontal collision
function Crawler_OnRightCollision(fVX) {} // -->|
function Crawler_OnLeftCollision(fVX) {} // |<--
function Crawler_OnXCollision(fVX, isOOB = false) {} // same as both above

// check if allowed to move "up" a slope while on the floor, like so:
//	  ->/
//	 - /
//	- /
function Crawler_CanMoveUpSlope_Bottom()
{
	return (colEdge == Edge.Bottom || colEdge == Edge.None);
}
function Crawler_OnSlopeXCollision_Bottom(fVX, yShift) // -->/
{
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Bottom;
	}
}

// check if allowed to move "down" a slope while on the floor, like so:
//	\ -
//	 \ -
//	  \ ->
function Crawler_CanMoveDownSlope_Bottom()
{
	return (colEdge == Edge.Bottom);
}

// check if allowed to move "up" a slope while on the ceiling, like so:
//	- \
//	 - \
//	  ->\
function Crawler_CanMoveUpSlope_Top()
{
	return (colEdge == Edge.Top || colEdge == Edge.None);
}
function Crawler_OnSlopeXCollision_Top(fVX, yShift) // -->\
{
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Top;
	}
}

// check if allowed to move "down" a slope while on the ceiling, like so:
//	  / ->
//	 / -
//	/ -
function Crawler_CanMoveDownSlope_Top()
{
	return (colEdge == Edge.Top);
}


// called on vertical collision
function Crawler_OnBottomCollision(fVY) {}
function Crawler_OnTopCollision(fVY) {}
function Crawler_OnYCollision(fVY, isOOB = false) {} // same as both above

// check if allowed to move "up" a slope on the right wall, like so:
//	^ \
//	 | \
//	  | \
function Crawler_CanMoveUpSlope_Right()
{
	return (colEdge == Edge.Right || colEdge == Edge.None);
}
function Crawler_OnSlopeYCollision_Right(fVY, xShift)
{
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Right;
	}
}

// check if allowed to move "down" a slope on the right wall, like so:
//	  ^ /
//	 | /
//	| /
function Crawler_CanMoveDownSlope_Right()
{
	return (colEdge == Edge.Right);
}

// check if allowed to move "up" a slope on the left wall, like so:
//	  / ^
//	 / |
//	/ |
function Crawler_CanMoveUpSlope_Left()
{
	return (colEdge == Edge.Left || colEdge == Edge.None);
}
function Crawler_OnSlopeYCollision_Left(fVY, xShift)
{
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Left;
	}
}

// check if allowed to move "down" a slope on the left wall, like so:
//	\ ^
//	 \ |
//	  \ |
function Crawler_CanMoveDownSlope_Left()
{
	return (colEdge == Edge.Left);
}

#endregion
#region Collision_Crawler
function Collision_Crawler(vX, vY, slopeSpeedAdjust, ignoreOOB = false)
{
	oldPosition.Equals(position);
	
	if(slopeSpeedAdjust)
	{
		if(colEdge != Edge.None)
		{
			var sAngle = 0;
			switch(colEdge)
			{
				case Edge.Bottom:
				{
					sAngle = self.GetEdgeAngle(colEdge);
					break;
				}
				case Edge.Right:
				{
					sAngle = angle_difference(self.GetEdgeAngle(colEdge),90);
					break;
				}
				case Edge.Top:
				{
					sAngle = angle_difference(self.GetEdgeAngle(colEdge),180);
					break;
				}
				case Edge.Left:
				{
					sAngle = angle_difference(self.GetEdgeAngle(colEdge),270);
					break;
				}
			}
			vX = lengthdir_x(vX,sAngle);
			vY = lengthdir_x(vY,sAngle);
		}
		else
		{
			var sAngle = 0;
			var _btm = self.entity_place_collide(0,2), _top = self.entity_place_collide(0,-2);
			if(_btm && !_top)
			{
				sAngle = self.GetEdgeAngle(Edge.Bottom);
			}
			if(_top && !_btm)
			{
				sAngle = angle_difference(self.GetEdgeAngle(Edge.Top),180);
			}
			vX = lengthdir_x(vX,sAngle);
			
			sAngle = 0;
			var _rgt = self.entity_place_collide(2,0), _lft = self.entity_place_collide(-2,0);
			if(_rgt && !_lft)
			{
				sAngle = angle_difference(self.GetEdgeAngle(Edge.Right),90);
			}
			if(_lft && !_rgt)
			{
				sAngle = angle_difference(self.GetEdgeAngle(Edge.Left),270);
			}
			vY = lengthdir_x(vY,sAngle);
		}
	}
	
	vX += shiftX;
	vY += shiftY;
	
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while(maxSpeedX > 0 || maxSpeedY > 0)
	{
		var fVX = self.Crawler_ModifyFinalVelX(min(maxSpeedX,1)*sign(vX));
		if(fVX != 0)
		{
			#region X Collision
		
			self.DestroyBlock(position.X+fVX,position.Y);
		
			var colClip = self.entity_place_collide(0,0);
			var colR = self.entity_collision_line(self.bb_right()+fVX,self.bb_top(),self.bb_right()+fVX,self.bb_bottom()),
				colL = self.entity_collision_line(self.bb_left()+fVX,self.bb_top(),self.bb_left()+fVX,self.bb_bottom());
			if(self.entity_place_collide(sign(fVX),0) && (!colClip || (fVX > 0 && colR) || (fVX < 0 && colL)))
			{
				var steepness = self.ModifySlopeXSteepness_Up();
				var xnum = sign(fVX);
				if(steepness < 1)
				{
					xnum = scr_round(1/steepness) * sign(fVX);
					steepness = 1;
				}
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveUpSlope_Bottom = (self.Crawler_CanMoveUpSlope_Bottom() && !self.entity_place_collide(xnum,-steepness) && self.entity_place_collide(0,steepness));
				var moveUpSlope_Top = (self.Crawler_CanMoveUpSlope_Top() && !self.entity_place_collide(xnum,steepness) && self.entity_place_collide(0,-steepness));
				var horizontalEdge = (colEdge == Edge.Bottom || colEdge == Edge.Top);
				var ydir = 0;
				if(colEdge == Edge.Bottom)
				{
					ydir = -1;
				}
				if(colEdge == Edge.Top)
				{
					ydir = 1;
				}
			
				var yplus = 0;
				if(moveUpSlope_Bottom)
				{
					while(self.entity_place_collide(fVX,yplus) && yplus > -steepness)
					{
						yplus--;
					}
				}
				if(moveUpSlope_Top)
				{
					while(self.entity_place_collide(fVX,yplus) && yplus < steepness)
					{
						yplus++;
					}
				}
			
				if(self.entity_place_collide(fVX,yplus) || (!moveUpSlope_Bottom && !moveUpSlope_Top) || (!horizontalEdge && colEdge != Edge.None))
				{
					if(fVX > 0)
					{
						position.X = scr_floor(position.X);
					}
					if(fVX < 0)
					{
						position.X = scr_ceil(position.X);
					}
					if(!self.entity_place_collide(sign(fVX),0))
					{
						position.X += sign(fVX);
					}
					
					if(fVX > 0)
					{
						if(self.Crawler_CanStickRight() && (horizontalEdge || colEdge == Edge.None))
						{
							if(horizontalEdge)
							{
								vY = abs(vX)*ydir;
								maxSpeedY = maxSpeedX;
							}
							colEdge = Edge.Right;
						}
						else if(!self.Crawler_CanStickRight() && colEdge = Edge.Right)
						{
							colEdge = Edge.None;
						}
						self.Crawler_OnRightCollision(fVX);
					}
					if(fVX < 0)
					{
						if(self.Crawler_CanStickLeft() && (horizontalEdge || colEdge == Edge.None))
						{
							if(horizontalEdge)
							{
								vY = abs(vX)*ydir;
								maxSpeedY = maxSpeedX;
							}
							colEdge = Edge.Left;
						}
						else if(!self.Crawler_CanStickLeft() && colEdge == Edge.Left)
						{
							colEdge = Edge.None;
						}
						self.Crawler_OnLeftCollision(fVX);
					}
					self.Crawler_OnXCollision(fVX);
					
					fVX = 0;
					maxSpeedX = 0;
				}
				else
				{
					if(yplus > 0)
					{
						self.Crawler_OnSlopeXCollision_Top(fVX,yplus);
						position.Y = floor(position.Y + yplus);
						if(self.entity_place_collide(fVX,0))
						{
							position.Y += 1;
						}
					}
					else
					{
						self.Crawler_OnSlopeXCollision_Bottom(fVX,yplus);
						position.Y = ceil(position.Y + yplus);
						if(self.entity_place_collide(fVX,0))
						{
							position.Y -= 1;
						}
					}
				}
			}
			else if(!colClip && colEdge != Edge.Right && colEdge != Edge.Left)
			{
				var steepness = self.ModifySlopeXSteepness_Down();
				var xnum = sign(fVX);
				if(steepness < 1)
				{
					xnum = scr_round(1/steepness) * sign(fVX);
					steepness = 1;
				}
				steepness += 1;
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveDownSlope_Bottom = (self.Crawler_CanMoveDownSlope_Bottom() && self.entity_place_collide(0,1) && self.entity_place_collide(xnum,steepness));
				var moveDownSlope_Top = (self.Crawler_CanMoveDownSlope_Top() && self.entity_place_collide(0,-1) && self.entity_place_collide(xnum,-steepness));
			
				var ydir = 0;
				if(colEdge == Edge.Bottom || (colEdge == Edge.None && self.entity_place_collide(0,1)))
				{
					ydir = 1;
				}
				if(colEdge == Edge.Top || (colEdge == Edge.None && self.entity_place_collide(0,-1)))
				{
					ydir = -1;
				}
			
				if(moveDownSlope_Bottom || moveDownSlope_Top)
				{
					var yplus2 = 0;
					if(moveDownSlope_Bottom)
					{
						while(!self.entity_place_collide(fVX,yplus2+1) && yplus2 < steepness)
						{
							yplus2++;
						}
					}
					if(moveDownSlope_Top)
					{
						while(!self.entity_place_collide(fVX,yplus2-1) && yplus2 > -steepness)
						{
							yplus2--;
						}
					}
				
					if(!self.entity_place_collide(fVX,yplus2))
					{
						if(self.entity_place_collide(fVX,yplus2+sign(yplus2)))
						{
							if(yplus2 > 0)
							{
								position.Y = ceil(position.Y + yplus2);
								if(self.entity_place_collide(fVX,0))
								{
									position.Y -= 1;
								}
							}
							else
							{
								position.Y = floor(position.Y + yplus2);
								if(self.entity_place_collide(fVX,0))
								{
									position.Y += 1;
								}
							}
						}
					}
				}
				else if(ydir != 0 && !self.entity_place_collide(sign(fVX),ydir))
				{
					var _checkFlag = false;
					if(self.Crawler_CanStickOuterLeft())
					{
						if(fVX > 0)
						{
							colEdge = Edge.Left;
							position.X = scr_ceil(position.X);
							_checkFlag = true;
						}
					}
					else if(fVX > 0)
					{
						colEdge = Edge.None;
					}
					if(self.Crawler_CanStickOuterRight())
					{
						if(fVX < 0)
						{
							colEdge = Edge.Right;
							position.X = scr_floor(position.X);
							_checkFlag = true;
						}
					}
					else if(fVX < 0)
					{
						colEdge = Edge.None;
					}
					
					if(_checkFlag)
					{
						if(self.entity_place_collide(0,ydir))
						{
							position.X += sign(fVX);
						}
						if(!self.entity_place_collide(0,ydir))
						{
							position.Y += ydir;
						}
						vY = abs(vX)*ydir;
						maxSpeedY = maxSpeedX;
						vX *= -1;
						
						fVX = 0;
						maxSpeedX = 0;
					}
				}
			}
			#endregion
			
			position.X += fVX;
		}
		if(!ignoreOOB && (position.X > room_width || position.X < 0))
		{
			if(position.X > room_width)
			{
				self.Crawler_OnRightCollision(fVX);
			}
			if(position.X < 0)
			{
				self.Crawler_OnLeftCollision(fVX);
			}
			self.Crawler_OnXCollision(fVX, true);
			position.X = clamp(position.X,0,room_width);
		}
		x = scr_round(position.X);
		
		var fVY = self.Crawler_ModifyFinalVelY(min(maxSpeedY,1)*sign(vY));
		if(fVY != 0)
		{
			#region Y Collision
		
			self.DestroyBlock(position.X,position.Y+fVY);
		
			var colClip = self.entity_place_collide(0,0);
			var colB = self.entity_collision_line(self.bb_left(),self.bb_bottom()+fVY,self.bb_right(),self.bb_bottom()+fVY),
				colT = self.entity_collision_line(self.bb_left(),self.bb_top()+fVY,self.bb_right(),self.bb_top()+fVY);
			if(self.entity_place_collide(0,sign(fVY)) && (!colClip || (fVY > 0 && colB) || (fVY < 0 && colT)))
			{
				var steepness = self.ModifySlopeYSteepness_Up();
				var ynum = sign(fVY);
				if(steepness < 1)
				{
					ynum = scr_round(1/steepness) * sign(fVY);
					steepness = 1;
				}
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveUpSlope_Right = (self.Crawler_CanMoveUpSlope_Right() && !self.entity_place_collide(-steepness,ynum) && self.entity_place_collide(steepness,0));
				var moveUpSlope_Left = (self.Crawler_CanMoveUpSlope_Left() && !self.entity_place_collide(steepness,ynum) && self.entity_place_collide(-steepness,0));
				var verticalEdge = (colEdge == Edge.Left || colEdge == Edge.Right);
				var xdir = 0;
				if(colEdge == Edge.Right)
				{
					xdir = -1;
				}
				if(colEdge == Edge.Left)
				{
					xdir = 1;
				}
			
				var xplus = 0;
				if(moveUpSlope_Right)
				{
					while(self.entity_place_collide(xplus,fVY) && xplus > -steepness)
					{
						xplus--;
					}
				}
				if(moveUpSlope_Left)
				{
					while(self.entity_place_collide(xplus,fVY) && xplus < steepness)
					{
						xplus++;
					}
				}
			
				if(self.entity_place_collide(xplus,fVY) || (!moveUpSlope_Right && !moveUpSlope_Left) || (!verticalEdge && colEdge != Edge.None))
				{
					if(fVY > 0)
					{
						position.Y = scr_floor(position.Y);
					}
					if(fVY < 0)
					{
						position.Y = scr_ceil(position.Y);
					}
					if(!self.entity_place_collide(0,sign(fVY)))
					{
						position.Y += sign(fVY);
					}
					
					if(fVY > 0)
					{
						if(self.Crawler_CanStickBottom() && (verticalEdge || colEdge == Edge.None))
						{
							if(verticalEdge)
							{
								vX = abs(vY)*xdir;
								maxSpeedX = maxSpeedY;
							}
							colEdge = Edge.Bottom;
						}
						else if(!self.Crawler_CanStickBottom() && colEdge == Edge.Bottom)
						{
							colEdge = Edge.None;
						}
						self.Crawler_OnBottomCollision(fVY);
					}
					if(fVY < 0)
					{
						if(self.Crawler_CanStickTop() && (verticalEdge || colEdge == Edge.None))
						{
							if(verticalEdge)
							{
								vX = abs(vY)*xdir;
								maxSpeedX = maxSpeedY;
							}
							colEdge = Edge.Top;
						}
						else if(!self.Crawler_CanStickTop() && colEdge == Edge.Top)
						{
							colEdge = Edge.None;
						}
						self.Crawler_OnTopCollision(fVY);
					}
					self.Crawler_OnYCollision(fVY);
					fVY = 0;
					maxSpeedY = 0;
				}
				else
				{
					if(xplus > 0)
					{
						self.Crawler_OnSlopeYCollision_Left(fVY,xplus);
						position.X = floor(position.X + xplus);
						if(self.entity_place_collide(0,fVY))
						{
							position.X += 1;
						}
					}
					else
					{
						self.Crawler_OnSlopeYCollision_Right(fVY,xplus);
						position.X = ceil(position.X + xplus);
						if(self.entity_place_collide(0,fVY))
						{
							position.X -= 1;
						}
					}
				}
			}
			else if(!colClip && colEdge != Edge.Bottom && colEdge != Edge.Top)
			{
				var steepness = self.ModifySlopeYSteepness_Down();
				var ynum = sign(fVY);
				if(steepness < 1)
				{
					ynum = scr_round(1/steepness) * sign(fVY);
					steepness = 1;
				}
				steepness += 1;
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveDownSlope_Right = (self.Crawler_CanMoveDownSlope_Right() && self.entity_place_collide(1,0) && self.entity_place_collide(steepness,ynum));
				var moveDownSlope_Left = (self.Crawler_CanMoveDownSlope_Left() && self.entity_place_collide(-1,0) && self.entity_place_collide(-steepness,ynum));
			
				var xdir = 0;
				if(colEdge == Edge.Right || (colEdge == Edge.None && self.entity_place_collide(1,0)))
				{
					xdir = 1;
				}
				if(colEdge == Edge.Left || (colEdge == Edge.None && self.entity_place_collide(-1,0)))
				{
					xdir = -1;
				}
			
				if(moveDownSlope_Right || moveDownSlope_Left)
				{
					var xplus2 = 0;
					if(moveDownSlope_Right)
					{
						while(!self.entity_place_collide(1+xplus2,fVY) && xplus2 < steepness)
						{
							xplus2++;
						}
					}
					if(moveDownSlope_Left)
					{
						while(!self.entity_place_collide(-1+xplus2,fVY) && xplus2 > -steepness)
						{
							xplus2--;
						}
					}
				
					if(!self.entity_place_collide(xplus2,fVY))
					{
						if(self.entity_place_collide(xplus2+sign(xplus2),fVY))
						{
							if(xplus2 > 0)
							{
								position.X = ceil(position.X + xplus2);
								if(self.entity_place_collide(0,fVY))
								{
									position.X -= 1;
								}
							}
							else
							{
								position.X = floor(position.X + xplus2);
								if(self.entity_place_collide(0,fVY))
								{
									position.X += 1;
								}
							}
						}
					}
				}
				else if(xdir != 0 && !self.entity_place_collide(xdir,sign(fVY)))
				{
					var _checkFlag = false;
					if(self.Crawler_CanStickOuterTop())
					{
						if(fVY > 0)
						{
							colEdge = Edge.Top;
							position.Y = scr_ceil(position.Y);
							_checkFlag = true;
						}
					}
					else if(fVY >= 0)
					{
						colEdge = Edge.None;
					}
					if(self.Crawler_CanStickOuterBottom())
					{
						if(fVY < 0)
						{
							colEdge = Edge.Bottom;
							position.Y = scr_floor(position.Y);
							_checkFlag = true;
						}
					}
					else if(fVY <= 0)
					{
						colEdge = Edge.None;
					}
					
					if(_checkFlag && colEdge != Edge.None)
					{
						if(self.entity_place_collide(xdir,0))
						{
							position.Y += sign(fVY);
						}
						if(!self.entity_place_collide(xdir,0))
						{
							position.X += xdir;
						}
						vX = abs(vY)*xdir;
						maxSpeedX = maxSpeedY;
						vY *= -1;
						
						fVY = 0;
						maxSpeedY = 0;
					}
				}
			}
		
			#endregion
			
			position.Y += fVY;
		}
		if(!ignoreOOB && (position.Y > room_height || position.Y < 0))
		{
			if(position.Y > room_height)
			{
				self.Crawler_OnBottomCollision(fVX);
			}
			if(position.Y < 0)
			{
				self.Crawler_OnTopCollision(fVX);
			}
			self.Crawler_OnYCollision(fVX, true);
			position.Y = clamp(position.Y,0,room_height);
		}
		y = scr_round(position.Y);
		
		maxSpeedX = max(maxSpeedX-1,0);
		maxSpeedY = max(maxSpeedY-1,0);
	}
	
	shiftX = 0;
	shiftY = 0;
	
	movedVelX = 0;
	movedVelY = 0;
}
#endregion

#region Moving Solid Hooks

mBlocks = [];
mBlockOffset = [];
function UpdateMovingTiles(xx = undefined, yy = undefined, avoidClipping = false, _controlEntity = noone)
{
	/// @description UpdateMovingTiles
	/// @param baseX=position.X
	/// @param baseY=position.Y
	/// @param avoidClipping=false
	
	xx = is_undefined(xx) ? position.X : xx;
	yy = is_undefined(yy) ? position.Y : yy;
	
	if(array_length(mBlocks) > 0)
	{
		for(var i = 0; i < array_length(mBlocks); i++)
		{
			if(!instance_exists(mBlocks[i])) continue;
			
			mBlocks[i].tempIgnoredEnt = _controlEntity;
			var _posX = xx,
				_posY = yy;
			if(array_length(mBlockOffset) > i && is_struct(mBlockOffset[i]))
			{
				_posX += mBlockOffset[i].X;
				_posY += mBlockOffset[i].Y;
			}
			mBlocks[i].isSolid = false;
			mBlocks[i].UpdatePosition(_posX, _posY, avoidClipping, id);
			mBlocks[i].isSolid = true;
		}
	}
}

passthroughMovingSolids = false;

function MoveStickBottom_X(movingTile) { return (colEdge == Edge.Bottom); }
function MoveStickBottom_Y(movingTile) { return (colEdge == Edge.Bottom); }
function MoveStickTop_X(movingTile) { return (colEdge == Edge.Top); }
function MoveStickTop_Y(movingTile) { return (colEdge == Edge.Top); }
function MoveStickRight_X(movingTile) { return (colEdge == Edge.Right); }
function MoveStickRight_Y(movingTile) { return (colEdge == Edge.Right); }
function MoveStickLeft_X(movingTile) { return (colEdge == Edge.Left); }
function MoveStickLeft_Y(movingTile) { return (colEdge == Edge.Left); }

// called on horizontal collision
function MovingSolid_OnRightCollision(fVX) {} // -->|
function MovingSolid_OnLeftCollision(fVX) {} // |<--
function MovingSolid_OnXCollision(fVX) {} // same as both above

// called on vertical collision
function MovingSolid_OnBottomCollision(fVY) {}
function MovingSolid_OnTopCollision(fVY) {}
function MovingSolid_OnYCollision(fVY) {} // same as both above

#endregion
#region Collision_MovingSolid
function Collision_MovingSolid(vX, vY, _controlEntity = noone)
{
	var upSlopeSteepness_X = 2,
		downSlopeSteepness_X = 2,
		upSlopeSteepness_Y = 2,
		downSlopeSteepness_Y = 2;
	
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while(maxSpeedX > 0 || maxSpeedY > 0)
	{
		var fVX = min(maxSpeedX,1)*sign(vX);
		if(fVX != 0)
		{
			#region X Collision
		
			self.DestroyBlock(position.X+fVX,position.Y);
		
			var colClip = self.entity_place_collide(0,0);
			var colR = self.entity_collision_line(self.bb_right()+fVX,self.bb_top(),self.bb_right()+fVX,self.bb_bottom()),
				colL = self.entity_collision_line(self.bb_left()+fVX,self.bb_top(),self.bb_left()+fVX,self.bb_bottom());
			if(self.entity_place_collide(sign(fVX),0) && (!colClip || (fVX > 0 && colR) || (fVX < 0 && colL)))
			{
				var steepness = upSlopeSteepness_X;
				var xnum = sign(fVX);
				if(steepness < 1)
				{
					xnum = (1/steepness) * sign(fVX);
					steepness = 1;
				}
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveUpSlope_Bottom = (!self.entity_place_collide(xnum,-steepness) && self.entity_place_collide(0,steepness) && steepness > 0);
				var moveUpSlope_Top = (!self.entity_place_collide(xnum,steepness) && self.entity_place_collide(0,-steepness) && steepness > 0);
			
				var yplus = 0;
				if(moveUpSlope_Bottom)
				{
					while(self.entity_place_collide(fVX,yplus) && yplus > -steepness)
					{
						yplus--;
					}
				}
				if(moveUpSlope_Top)
				{
					while(self.entity_place_collide(fVX,yplus) && yplus < steepness)
					{
						yplus++;
					}
				}
			
				if(self.entity_place_collide(fVX,yplus) || (!moveUpSlope_Bottom && !moveUpSlope_Top))
				{
					if(fVX > 0)
					{
						position.X = scr_floor(position.X);
					}
					if(fVX < 0)
					{
						position.X = scr_ceil(position.X);
					}
					if(!self.entity_place_collide(sign(fVX),0))
					{
						position.X += sign(fVX);
					}
				
					if(fVX > 0)
					{
						self.MovingSolid_OnRightCollision(fVX);
					}
					if(fVX < 0)
					{
						self.MovingSolid_OnLeftCollision(fVX);
					}
					self.MovingSolid_OnXCollision(fVX);
					fVX = 0;
					maxSpeedX = 0;
				}
				else
				{
					if(yplus > 0)
					{
						position.Y = floor(position.Y + yplus);
						if(self.entity_place_collide(fVX,0))
						{
							position.Y += 1;
						}
					}
					else
					{
						position.Y = ceil(position.Y + yplus);
						if(self.entity_place_collide(fVX,0))
						{
							position.Y -= 1;
						}
					}
				}
			}
			else if(!colClip)
			{
				var steepness = downSlopeSteepness_X;
				var xnum = sign(fVX);
				if(steepness < 1)
				{
					xnum = (1/steepness) * sign(fVX);
					steepness = 1;
				}
				steepness += 1;
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveDownSlope_Bottom = (self.entity_place_collide(0,1) && self.entity_place_collide(xnum,steepness));
				var moveDownSlope_Top = (self.entity_place_collide(0,-1) && self.entity_place_collide(xnum,-steepness));
			
				if(moveDownSlope_Bottom || moveDownSlope_Top)
				{
					var yplus2 = 0;
					if(moveDownSlope_Bottom)
					{
						while(!self.entity_place_collide(fVX,yplus2+1) && yplus2 < steepness)
						{
							yplus2++;
						}
					}
					if(moveDownSlope_Top)
					{
						while(!self.entity_place_collide(fVX,yplus2-1) && yplus2 > -steepness)
						{
							yplus2--;
						}
					}
				
					if(!self.entity_place_collide(fVX,yplus2))
					{
						if(self.entity_place_collide(fVX,yplus2+sign(yplus2)))
						{
							if(yplus2 > 0)
							{
								position.Y = ceil(position.Y + yplus2);
								if(self.entity_place_collide(fVX,0))
								{
									position.Y -= 1;
								}
							}
							else
							{
								position.Y = floor(position.Y + yplus2);
								if(self.entity_place_collide(fVX,0))
								{
									position.Y += 1;
								}
							}
						}
					}
				}
			}
			#endregion
			
			position.X += fVX;
		}
		x = scr_round(position.X);
		
		var fVY = min(maxSpeedY,1)*sign(vY);
		if(fVY != 0)
		{
			#region Y Collision
		
			self.DestroyBlock(position.X,position.Y+fVY);
		
			var colClip = self.entity_place_collide(0,0);
			var colB = self.entity_collision_line(self.bb_left(),self.bb_bottom()+fVY,self.bb_right(),self.bb_bottom()+fVY),
				colT = self.entity_collision_line(self.bb_left(),self.bb_top()+fVY,self.bb_right(),self.bb_top()+fVY);
			if(self.entity_place_collide(0,sign(fVY)) && (!colClip || (fVY > 0 && colB) || (fVY < 0 && colT)))
			{
				var steepness = upSlopeSteepness_Y;
				var ynum = sign(fVY);
				if(steepness < 1)
				{
					ynum = (1/steepness) * sign(fVY);
					steepness = 1;
				}
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveUpSlope_Right = (!self.entity_place_collide(-steepness,ynum) && self.entity_place_collide(steepness,0) && steepness > 0);
				var moveUpSlope_Left = (!self.entity_place_collide(steepness,ynum) && self.entity_place_collide(-steepness,0) && steepness > 0);
			
				var xplus = 0;
				if(moveUpSlope_Right)
				{
					while(self.entity_place_collide(xplus,fVY) && xplus > -steepness)
					{
						xplus--;
					}
				}
				if(moveUpSlope_Left)
				{
					while(self.entity_place_collide(xplus,fVY) && xplus < steepness)
					{
						xplus++;
					}
				}
			
				if(self.entity_place_collide(xplus,fVY) || (!moveUpSlope_Right && !moveUpSlope_Left))
				{
					if(fVY > 0)
					{
						position.Y = scr_floor(position.Y);
					}
					if(fVY < 0)
					{
						position.Y = scr_ceil(position.Y);
					}
					if(!self.entity_place_collide(0,sign(fVY)))
					{
						position.Y += sign(fVY);
					}
				
					if(fVY > 0)
					{
						self.MovingSolid_OnBottomCollision(fVY);
					}
					if(fVY < 0)
					{
						self.MovingSolid_OnTopCollision(fVY);
					}
					self.MovingSolid_OnYCollision(fVY);
					fVY = 0;
					maxSpeedY = 0;
				}
				else
				{
					if(xplus > 0)
					{
						position.X = floor(position.X + xplus);
						if(self.entity_place_collide(0,fVY))
						{
							position.X += 1;
						}
					}
					else
					{
						position.X = ceil(position.X + xplus);
						if(self.entity_place_collide(0,fVY))
						{
							position.X -= 1;
						}
					}
				}
			}
			else if(!colClip)
			{
				var steepness = downSlopeSteepness_Y;
				var ynum = sign(fVY);
				if(steepness < 1)
				{
					ynum = (1/steepness) * sign(fVY);
					steepness = 1;
				}
				steepness += 1;
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveDownSlope_Right = (self.entity_place_collide(1,0) && self.entity_place_collide(steepness,ynum));
				var moveDownSlope_Left = (self.entity_place_collide(-1,0) && self.entity_place_collide(-steepness,ynum));
			
				if(moveDownSlope_Right || moveDownSlope_Left)
				{
					var xplus2 = 0;
					if(moveDownSlope_Right)
					{
						while(!self.entity_place_collide(1+xplus2,fVY) && xplus2 < steepness)
						{
							xplus2++;
						}
					}
					if(moveDownSlope_Left)
					{
						while(!self.entity_place_collide(-1+xplus2,fVY) && xplus2 > -steepness)
						{
							xplus2--;
						}
					}
				
					if(!self.entity_place_collide(xplus2,fVY))
					{
						if(self.entity_place_collide(xplus2+sign(xplus2),fVY))
						{
							if(xplus2 > 0)
							{
								position.X = ceil(position.X + xplus2);
								if(self.entity_place_collide(0,fVY))
								{
									position.X -= 1;
								}
							}
							else
							{
								position.X = floor(position.X + xplus2);
								if(self.entity_place_collide(0,fVY))
								{
									position.X += 1;
								}
							}
						}
					}
				}
			}
		
			#endregion
			
			position.Y += fVY;
		}
		y = scr_round(position.Y);
		
		maxSpeedX = max(maxSpeedX-1,0);
		maxSpeedY = max(maxSpeedY-1,0);
	}
	
	self.UpdateMovingTiles(x,y,false, _controlEntity);
}
#endregion

enum BlockBreakType
{
	Shot,
	Missile,
	SMissile,
	Bomb,
	Chain,
	PBomb,
	BoostBall,
	Speed,
	Screw,
	
	_Length
}
blockBreakType = array_create(BlockBreakType._Length, false);
#region BreakBlock
function BreakBlock(xx,yy,type)
{
	if(place_meeting(xx,yy,obj_Breakable) && array_length(type) >= BlockBreakType._Length)
	{
		var bArr = [],
			i = 0;
		if(type[BlockBreakType.Shot])
		{
			bArr[i] = obj_ShotBlock;
			i++;
		}
		
		if(type[BlockBreakType.Missile])
		{
			bArr[i] = obj_MissileBlock;
			i++;
		}
		if(type[BlockBreakType.SMissile])
		{
			bArr[i] = obj_SuperMissileBlock;
			i++;
		}
		
		if(type[BlockBreakType.Bomb])
		{
			bArr[i] = obj_BombBlock;
			i++;
		}
		if(type[BlockBreakType.Chain])
		{
			bArr[i] = obj_ChainBlock;
			i++;
		}
		if(type[BlockBreakType.PBomb])
		{
			bArr[i] = obj_PowerBombBlock;
			i++;
		}
		
		if(type[BlockBreakType.BoostBall])
		{
			bArr[i] = obj_BoostBallBlock;
			i++;
		}
		if(type[BlockBreakType.Speed])
		{
			bArr[i] = obj_SpeedBlock;
			i++;
		}
		if(type[BlockBreakType.Screw])
		{
			bArr[i] = obj_ScrewBlock;
			//i++;
		}
		
		self.DestroyObject(xx,yy,bArr);
	}
}
breakList = ds_list_create();
function DestroyObject(xx,yy,objIndex)
{
	var _num = instance_place_list(xx,yy,objIndex,breakList,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			if(instance_exists(breakList[| i]))
			{
				instance_destroy(breakList[| i]);
			}
		}
	}
	ds_list_clear(breakList);
}
#endregion

enum DoorOpenType
{
	Beam,
	Charge,
	Ice,
	Wave,
	Spazer,
	Plasma,
	Missile,
	SMissile,
	Bomb,
	PBomb,
	
	_Length
}
doorOpenType = array_create(DoorOpenType._Length, false);
#region OpenDoor
function OpenDoor(_x,_y,_type)
{
	if(place_meeting(_x,_y,obj_DoorHatch) && array_length(_type) >= DoorOpenType._Length)
	{
		var dArr = [],
			i = 0,
			dmg = 1;
		
		if(_type[DoorOpenType.Beam])
		{
			dArr[i] = obj_DoorHatch_Blue;
			i++;
			dArr[i] = obj_DoorHatch_Locked;
			i++;
		}
		
		if(_type[DoorOpenType.Missile])
		{
			dArr[i] = obj_DoorHatch_Missile;
			i++;
		}
		if(_type[DoorOpenType.SMissile])
		{
			dArr[i] = obj_DoorHatch_Super;
			i++;
			dmg = 5;
		}
		
		if(_type[DoorOpenType.PBomb])
		{
			dArr[i] = obj_DoorHatch_Power;
			//i++;
		}
		
		self.DamageDoor(_x,_y,dArr,dmg);
	}
}
doorList = ds_list_create();
function DamageDoor(_x,_y,_objIndex,_dmg)
{
	var _num = instance_place_list(_x,_y,_objIndex,doorList,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			if(instance_exists(doorList[| i]) && doorList[| i].unlocked)
			{
				doorList[| i].DamageHatch(_dmg);
			}
		}
	}
	ds_list_clear(doorList);
}
#endregion
#region ShutterSwitch
switchLOSCheck = true; // toggle whether to do a Line of Sight check for switch activation
function ShutterSwitch(_x,_y,_type)
{
	if(place_meeting(_x,_y,obj_ShutterSwitch) && array_length(_type) >= DoorOpenType._Length)
	{
		var dArr = [],
			i = 0;
		
		if(_type[DoorOpenType.Beam])
		{
			dArr[i] = obj_ShutterSwitch_Blue;
			i++;
		}
		
		if(_type[DoorOpenType.Missile])
		{
			dArr[i] = obj_ShutterSwitch_Missile;
			i++;
		}
		if(_type[DoorOpenType.SMissile])
		{
			dArr[i] = obj_ShutterSwitch_Super;
			i++;
		}
		
		if(_type[DoorOpenType.Bomb])
		{
			dArr[i] = obj_ShutterSwitch_Bomb;
			i++;
		}
		if(_type[DoorOpenType.PBomb])
		{
			dArr[i] = obj_ShutterSwitch_Power;
			//i++;
		}
		
		self.ToggleSwitch(_x,_y,dArr);
	}
}
switchList = ds_list_create();
function ToggleSwitch(_x,_y,_objIndex)
{
	var _num = instance_place_list(_x,_y,_objIndex,switchList,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			if(instance_exists(switchList[| i]))
			{
				var sSwitch = switchList[| i];
				var flag = true;
				if(switchLOSCheck)
				{
					var entity = id,
						center = Center();
					with(sSwitch)
					{
						if(collision_line(center.X,center.Y,x,y,entity.solids,true,true))
						{
							flag = false;
						}
					}
				}
				if(flag)
				{
					if(id != sSwitch.lastProj || !object_is_ancestor(sSwitch.lastProj.object_index,obj_Projectile))
					{
						sSwitch.Toggle();
						sSwitch.lastProj = id;
					}
				}
			}
		}
	}
	ds_list_clear(switchList);
}
#endregion

#region liquid_place
function liquid_place()
{
	return instance_place(position.X,position.Y,obj_Liquid);
}
#endregion
#region liquid_top
function liquid_top()
{
	return collision_line(self.bb_left(), self.bb_top(), self.bb_right(), self.bb_top(), obj_Liquid, true, true);
}
#endregion

liquid = self.liquid_place();
liquidPrev = liquid;
liquidTop = self.liquid_top();
liquidTopPrev = liquidTop;

enteredLiquid = -1;
leftLiquid = -1;
leftLiquidTop = -1;
leftLiquidType = LiquidType.Water;
leftLiquidTopType = LiquidType.Water;

canSplash = 1;
breathTimer = 180;
stepSplash = 0;

prevTop = self.bb_top();
prevBottom = self.bb_bottom();

#region EntityLiquid

function EntityLiquid(_mass, _velX, _velY, _sound = true, _isBeam = false, _isMissile = false)
{
	liquid = self.liquid_place();
	liquidTop = self.liquid_top();
	enteredLiquid = max(enteredLiquid-1,0);
	leftLiquid = max(leftLiquid-1,0);
	leftLiquidTop = max(leftLiquidTop-1,0);
	
	var returnLiq = liquid;
	
	if(liquid != liquidPrev)
	{
		if(liquid && prevBottom < liquid.bb_top())
		{
			liquid.CreateSplash(id,_mass,_velX,_velY,true,_sound,_isBeam)
			enteredLiquid = (_mass+1) * 15;
		}
		else if(liquidPrev && self.bb_bottom() < liquidPrev.bb_top() && !_isBeam && !_isMissile)
		{
			liquidPrev.CreateSplash(id,_mass,_velX,0,false,_sound,false);
			returnLiq = liquidPrev;
			leftLiquid = (_mass+1) * 7.5;
			leftLiquidType = liquidPrev.liquidType;
		}
		liquidPrev = liquid;
	}
	
	if(liquidTop != liquidTopPrev)
	{
		if(!liquidTop && liquidTopPrev && self.bb_top() < liquidTopPrev.bb_top())
		{
			liquidTopPrev.CreateSplash(id,_mass,_velX,_velY,false,_sound,_isBeam);
			returnLiq = liquidTopPrev;
			leftLiquidTop = (_mass+1) * 12.5;
			leftLiquidTopType = liquidTopPrev.liquidType;
		}
		liquidTopPrev = liquidTop;
	}
	
	prevTop = self.bb_top();
	prevBottom = self.bb_bottom();
	
	return returnLiq;
}

#endregion
#region EntityLiquid_Large

function EntityLiquid_Large(_velX, _velY)
{
	self.EntityLiquid(2,_velX,_velY, true, false, false);
	
	canSplash++;
	if(canSplash > 10)
	{
		canSplash = 0;
	}
	
	if(liquid && !liquidTop && (canSplash%4) == 0)
	{
		liquid.CreateSplash_Extra(id,0,_velX,_velY,true,false);
	}
	
	if(liquid && enteredLiquid > 0 && choose(1,1,1,0) == 1)
	{
		var bub = liquid.CreateBubble(x-8+random(16),y+random_range(self.bb_top(0),self.bb_bottom(0)),0,0);
		bub.spriteIndex = sprt_WaterBubble;

		if (_velY > 0)
		{
			bub.velY += _velY/4;
		}

		if (enteredLiquid < 60)
		{
			bub.alpha *= (enteredLiquid/60);
			bub.alphaMult *= (enteredLiquid/60);
		}
	}
	
	if(leftLiquid && choose(1,1,1,0,0) == 1)
	{
		var drop = instance_create_depth(x-8+random(16),y+4,depth-1,obj_WaterDrop);
		drop.liquidType = leftLiquidType;
		with (drop)
		{
			if(position_meeting(x,y,obj_Liquid))
			{
				kill = true;
				instance_destroy();
			}
		}
	}
	if (leftLiquidTop && choose(1,1,1,0,0) == 1)
	{
		var drop = instance_create_depth(x-8+random(16),self.bb_bottom()+random(self.bb_top(0)+4),depth-1,obj_WaterDrop);
		drop.liquidType = leftLiquidTopType;
		with (drop)
		{
			if(position_meeting(x,y,obj_Liquid))
			{
				kill = true;
				instance_destroy();
			}
		}
	}
	
	stepSplash = max(stepSplash-1,0);
}

#endregion

enum DmgType
{
	None,
	
	Beam,
	Charge,
	
	Explosive,
	ExplSplash,
	
	Misc,
	
	_Length
}
enum DmgSubType_Beam
{
	All,
	
	Power,
	Ice,
	Wave,
	Spazer,
	Plasma,
	
	Hyper,
	
	_Length
}
enum DmgSubType_Explosive
{
	All,
	
	Missile,
	SuperMissile,
	Bomb,
	PowerBomb,
	
	_Length
}
enum DmgSubType_Misc
{
	All,
	
	Grapple,
	BoostBall,
	SpeedBoost,
	ScrewAttack,
	
	_Length
}

hostile = false;

#region Taking Damage

dmgResist = array_create(DmgType._Length);
dmgResist[DmgType.None] = array_create(1, 1);

dmgResist[DmgType.Beam] = array_create(DmgSubType_Beam._Length, 1);
dmgResist[DmgType.Charge] = array_create(DmgSubType_Beam._Length, 1);

dmgResist[DmgType.Explosive] = array_create(DmgSubType_Explosive._Length, 1);
dmgResist[DmgType.ExplSplash] = array_create(DmgSubType_Explosive._Length, 1);

dmgResist[DmgType.Misc] = array_create(DmgSubType_Misc._Length, 1);

function CalcDamageResist(_dmg, _dmgType, _dmgSubType)
{
	if ((_dmgType == DmgType.Beam || _dmgType == DmgType.Charge) && 
		array_length(_dmgSubType) > DmgSubType_Beam.Hyper && _dmgSubType[DmgSubType_Beam.Hyper])
	{
		return _dmg;
	}
	
	var _dmgMult = 0;
	for(var i = 1; i < array_length(dmgResist[_dmgType]); i++)
	{
		if(array_length(_dmgSubType) > i && _dmgSubType[i])
		{
			_dmgMult = max(_dmgMult, dmgResist[_dmgType][i]);
		}
	}
	_dmgMult *= dmgResist[_dmgType][0];
	
	return _dmg * _dmgMult;
}

frozen = 0;
frozenInvFrames = 0;
freezeImmune = false;

dmgAbsorb = false;

function Entity_CanTakeDamage(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType) { return true; }
function Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	return self.CalcDamageResist(_dmg, _dmgType, _dmgSubType);
}
function Entity_OnDamageTaken(_selfLifeBox, _dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _npcDeathType = -1) {}
function Entity_OnDamageTaken_Blocked(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600) {}

lifeBoxes = [noone];
function CreateLifeBox(_offsetX,_offsetY,_mask,_hostile)
{
	var lifeBox = instance_create_depth(x+_offsetX,y+_offsetY,0,obj_LifeBox);
	lifeBox.creator = id;
	lifeBox.offsetX = _offsetX;
	lifeBox.offsetY = _offsetY;
	lifeBox.mask_index = _mask;
	lifeBox.hostile = _hostile;
	
	return lifeBox;
}


#endregion

#region Dealing Damage

damageType = DmgType.None;
damageSubType = array_create(1,true);

freezeType = 0;
freezeTime = 600;
freezeKill = false;

playerInvFrames = 96; // 96 default | 60 for spikes
npcInvFrames = 8;

playerKnockBackDur = 5;
playerKnockBackSpd = 5;
function PlayerKnockBackDir(_player)
{
	var vec = self.Center(true),
		pVec = _player.Center(true);
	
	return point_direction(vec.X,vec.Y, pVec.X,pVec.Y);
}

ignorePlayerImmunity = false;

function Entity_CanDealDamage(_selfDmgBox, _lifeBox, _dmg, _dmgType, _dmgSubType) { return true; }
function Entity_ModifyDamageDealt(_selfDmgBox, _lifeBox, _dmg, _dmgType, _dmgSubType) { return _dmg; }
function Entity_OnDamageDealt(_selfDmgBox, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType) {}
function Entity_OnDamageDealt_Blocked(_selfDmgBox, _lifeBox, _dmg, _dmgType, _dmgSubType) {}

function Entity_OnDmgBoxCollision(_selfDmgBox, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType) {}

dmgBoxes = [noone];
function CreateDamageBox(_offsetX,_offsetY,_mask,_hostile)
{
	var dmgBox = instance_create_depth(x+_offsetX,y+_offsetY,0,obj_DamageBox);
	dmgBox.creator = id;
	dmgBox.offsetX = _offsetX;
	dmgBox.offsetY = _offsetY;
	dmgBox.mask_index = _mask;
	dmgBox.hostile = _hostile;
	
	return dmgBox;
}

#endregion

#region I-Frames

iFrameCounters = ds_list_create();
function InvFrameCounter(_instance, _invFrames) constructor
{
	instanceID = _instance;
	invFrames = _invFrames;
	
	function Update()
	{
		invFrames = max(invFrames - 1, 0);
	}
}
function GetInvFrames(_instance)
{
	if(ds_exists(iFrameCounters,ds_type_list))
	{
		for(var i = 0; i < ds_list_size(iFrameCounters); i++)
		{
			if(is_struct(iFrameCounters[| i]) && instance_exists(_instance) && iFrameCounters[| i].instanceID == _instance)
			{
				return iFrameCounters[| i].invFrames;
			}
		}
	}
	return 0;
}
function IncrInvFrames()
{
	if(ds_exists(iFrameCounters,ds_type_list))
	{
		for(var i = 0; i < ds_list_size(iFrameCounters); i++)
		{
			if(is_struct(iFrameCounters[| i]))
			{
				if(iFrameCounters[| i].invFrames > 0)
				{
					iFrameCounters[| i].Update();
				}
				else
				{
					delete iFrameCounters[| i];
					ds_list_delete(iFrameCounters,i);
				}
			}
		}
	}
}

#endregion
