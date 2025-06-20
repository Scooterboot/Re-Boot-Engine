/// @description Initialize

position = new Vector2(x,y);
oldPosition = new Vector2(position.X,position.Y);

#region BBox vars
function bb_left()
{
	/// @description bb_left
	/// @param baseX=position.X
	var xx = position.X;
	if(argument_count > 0)
	{
		xx = argument[0];
	}
	return bbox_left-x + xx;
}
function bb_right()
{
	/// @description bb_right
	/// @param baseX=position.X
	var xx = position.X;
	if(argument_count > 0)
	{
		xx = argument[0];
	}
	return bbox_right-x + xx - 1;
}
function bb_top()
{
	/// @description bb_top
	/// @param baseY=position.Y
	var yy = position.Y;
	if(argument_count > 0)
	{
		yy = argument[0];
	}
	return bbox_top-y + yy;
}
function bb_bottom()
{
	/// @description bb_bottom
	/// @param baseY=position.Y
	var yy = position.Y;
	if(argument_count > 0)
	{
		yy = argument[0];
	}
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
//edgeSlope = ds_list_create();

#region Base Collision Checks

function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = argument_count > 2 ? argument[2] : position.X,
		yy = argument_count > 3 ? argument[3] : position.Y;
	
	if(self.CanPlatformCollide() && place_meeting(xx+offsetX,yy+offsetY,ColType_Platform))
	{
		if(self.entityPlatformCheck(offsetX,offsetY,xx,yy))
		{
			return true;
		}
	}
	
	return self.entity_collision(instance_place_list(xx+offsetX,yy+offsetY,solids,blockList,true));
}

function entity_position_collide()
{
	/// @description entity_position_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = argument_count > 2 ? argument[2] : position.X,
		yy = argument_count > 3 ? argument[3] : position.Y;
	
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
					if(block.ignoredEntity == id)
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

function entityPlatformCheck()
{
	/// @description entityPlatformCheck
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=position.X
	/// @param baseY=position.Y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = argument_count > 2 ? argument[2] : position.X,
		yy = argument_count > 3 ? argument[3] : position.Y;
	
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
			while(!self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.Y) < maxY)
			{
				pos1.Y += ySign;
			}
			pos2.Y = pos1.Y;
			if(abs(pos1.Y) >= maxY)
			{
				return ang;
			}
			
			while(!self.entity_place_collide(pos1.X-1+offsetX,pos1.Y+offsetY) && self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.X) < maxX)
			{
				pos1.X -= 1;
			}
			while(!self.entity_place_collide(pos2.X+1+offsetX,pos2.Y+offsetY) && self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY) && abs(pos2.X) < maxX)
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
				while(!self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && abs(pos1.Y) < maxY)
				{
					pos1.Y += ySign;
				}
				while(self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && abs(pos2.Y) < maxY)
				{
					pos2.Y -= ySign;
				}
			}
			if(checkDir == -1)
			{
				while(self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && abs(pos1.Y) < maxY)
				{
					pos1.Y -= ySign;
				}
				while(!self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY) && abs(pos2.Y) < maxY)
				{
					pos2.Y += ySign;
				}
			}
			if(abs(pos1.Y) >= maxY || abs(pos2.Y) >= maxY)
			{
				return ang;
			}
			
			if(checkDir != 0 && pos1.Y != pos2.Y && 
			!self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && self.entity_place_collide(pos1.X+offsetX,pos1.Y+ySign+offsetY) && 
			!self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && self.entity_place_collide(pos2.X+offsetX,pos2.Y+ySign+offsetY))
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
			while(!self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
			{
				pos1.X += xSign;
			}
			pos2.X = pos1.X;
			if(abs(pos1.X) >= maxX)
			{
				return ang;
			}
			
			while(!self.entity_place_collide(pos1.X+offsetX,pos1.Y-1+offsetY) && self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.Y) < maxY)
			{
				pos1.Y -= 1;
			}
			while(!self.entity_place_collide(pos2.X+offsetX,pos2.Y+1+offsetY) && self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY) && abs(pos2.Y) < maxY)
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
				while(!self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
				{
					pos1.X += xSign;
				}
				while(self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && abs(pos2.X) < maxX)
				{
					pos2.X -= xSign;
				}
			}
			if(checkDir == -1)
			{
				while(self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && abs(pos1.X) < maxX)
				{
					pos1.X -= xSign;
				}
				while(!self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY) && abs(pos2.X) < maxX)
				{
					pos2.X += xSign;
				}
			}
			if(abs(pos1.X) >= maxX || abs(pos2.X) >= maxX)
			{
				return ang;
			}
			
			if(checkDir != 0 && pos1.X != pos2.X && 
			!self.entity_place_collide(pos1.X+offsetX,pos1.Y+offsetY) && self.entity_place_collide(pos1.X+xSign+offsetX,pos1.Y+offsetY) && 
			!self.entity_place_collide(pos2.X+offsetX,pos2.Y+offsetY) && self.entity_place_collide(pos2.X+xSign+offsetX,pos2.Y+offsetY))
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

function ModifySlopeXSteepness_Up() { return 3; }
function ModifySlopeXSteepness_Down() { return 4; }
function ModifySlopeYSteepness_Up() { return 3; }
function ModifySlopeYSteepness_Down() { return 4; }

// called on horizontal collision
function OnRightCollision(fVX) {} // -->|
function OnLeftCollision(fVX) {} // |<--
function OnXCollision(fVX) {} // same as both above

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
function OnYCollision(fVY) {} // same as both above

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
function Collision_Normal(vX, vY, slopeSpeedAdjust)
{
	if(slopeSpeedAdjust)
	{
		var sAngle = 0;
		if(self.entity_place_collide(0,2) ^^ self.entity_place_collide(0,-2))
		{
			if(self.entity_place_collide(0,2))
			{
				sAngle = self.GetEdgeAngle(Edge.Bottom);
			}
			if(self.entity_place_collide(0,-2))
			{
				sAngle = angle_difference(self.GetEdgeAngle(Edge.Top),180);
			}
		}
		vX = lengthdir_x(vX,sAngle);
		
		sAngle = 0;
		if(self.entity_place_collide(2,0) ^^ self.entity_place_collide(-2,0))
		{
			if(self.entity_place_collide(2,0))
			{
				sAngle = angle_difference(self.GetEdgeAngle(Edge.Right),90);
			}
			if(self.entity_place_collide(-2,0))
			{
				sAngle = angle_difference(self.GetEdgeAngle(Edge.Left),270);
			}
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
		
			var colR = self.entity_collision_line(self.bb_right()+fVX,self.bb_top(),self.bb_right()+fVX,self.bb_bottom()),
				colL = self.entity_collision_line(self.bb_left()+fVX,self.bb_top(),self.bb_left()+fVX,self.bb_bottom());
			if(self.entity_place_collide(sign(fVX),0) && (!self.entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
			{
				var steepness = self.ModifySlopeXSteepness_Up();
				var xnum = 2*sign(fVX);
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveUpSlope_Bottom = (!self.entity_place_collide(xnum,-steepness) && self.entity_place_collide(0,steepness) && self.CanMoveUpSlope_Bottom());
				var moveUpSlope_Top = (!self.entity_place_collide(xnum,steepness) && self.entity_place_collide(0,-steepness) && self.CanMoveUpSlope_Top());
			
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
			else if(!self.entity_place_collide(0,0))
			{
				var steepness = self.ModifySlopeXSteepness_Down();
				var xnum = 2*sign(fVX);
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveDownSlope_Bottom = (self.entity_place_collide(0,1) && self.entity_place_collide(xnum,steepness) && self.CanMoveDownSlope_Bottom());
				var moveDownSlope_Top = (self.entity_place_collide(0,-1) && self.entity_place_collide(xnum,-steepness) && self.CanMoveDownSlope_Top());
			
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
		
		var fVY = self.ModifyFinalVelY(min(maxSpeedY,1)*sign(vY));
		if(fVY != 0)
		{
			#region Y Collision
		
			self.DestroyBlock(position.X,position.Y+fVY);
		
			var colB = self.entity_collision_line(self.bb_left(),self.bb_bottom()+fVY,self.bb_right(),self.bb_bottom()+fVY),
				colT = self.entity_collision_line(self.bb_left(),self.bb_top()+fVY,self.bb_right(),self.bb_top()+fVY);
			if(self.entity_place_collide(0,sign(fVY)) && (!self.entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
			{
				var steepness = self.ModifySlopeYSteepness_Up();
				var ynum = 2*sign(fVY);
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveUpSlope_Right = (!self.entity_place_collide(-steepness,ynum) && self.entity_place_collide(steepness,0) && self.CanMoveUpSlope_Right());
				var moveUpSlope_Left = (!self.entity_place_collide(steepness,ynum) && self.entity_place_collide(-steepness,0) && self.CanMoveUpSlope_Left());
			
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
			else if(!self.entity_place_collide(0,0))
			{
				var steepness = self.ModifySlopeYSteepness_Down();
				var ynum = 2*sign(fVY);
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveDownSlope_Right = (self.entity_place_collide(1,0) && self.entity_place_collide(steepness,ynum) && self.CanMoveDownSlope_Right());
				var moveDownSlope_Left = (self.entity_place_collide(-1,0) && self.entity_place_collide(-steepness,ynum) && self.CanMoveDownSlope_Left());
			
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
	
	shiftX = 0;
	shiftY = 0;
	
	movedVelX = 0;
	movedVelY = 0;
}
#endregion

#region Crawler Collision Hooks

function Crawler_ModifyFinalVelX(fVX) { return fVX; }
function Crawler_ModifyFinalVelY(fVY) { return fVY; }

// check if slope speed adjustments are applicable
/*function Crawler_SlopeCheck(slope) // old
{
	return colEdge != Edge.None;
}*/

function Crawler_CanStickRight() { return true; }
function Crawler_CanStickLeft() { return true; }
function Crawler_CanStickOuterRight() { return true; }
function Crawler_CanStickOuterLeft() { return true; }

function Crawler_CanStickBottom() { return true; }
function Crawler_CanStickTop() { return true; }
function Crawler_CanStickOuterBottom() { return true; }
function Crawler_CanStickOuterTop() { return true; }


// called on horizontal collision
function Crawler_OnRightCollision(fVX) {} // -->|
function Crawler_OnLeftCollision(fVX) {} // |<--
function Crawler_OnXCollision(fVX) {} // same as both above

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
function Crawler_OnYCollision(fVY) {} // same as both above

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

//function Crawler_OnPlatformCollision(fVY) {}

//function Crawler_DestroyBlock(bx,by) {}

#endregion
#region Collision_Crawler
function Collision_Crawler(vX, vY, slopeSpeedAdjust)
{
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
			if(self.entity_place_collide(0,2) ^^ self.entity_place_collide(0,-2))
			{
				if(self.entity_place_collide(0,2))
				{
					sAngle = self.GetEdgeAngle(Edge.Bottom);
				}
				if(self.entity_place_collide(0,-2))
				{
					sAngle = angle_difference(self.GetEdgeAngle(Edge.Top),180);
				}
			}
			vX = lengthdir_x(vX,sAngle);
		
			sAngle = 0;
			if(self.entity_place_collide(2,0) ^^ self.entity_place_collide(-2,0))
			{
				if(self.entity_place_collide(2,0))
				{
					sAngle = angle_difference(self.GetEdgeAngle(Edge.Right),90);
				}
				if(self.entity_place_collide(-2,0))
				{
					sAngle = angle_difference(self.GetEdgeAngle(Edge.Left),270);
				}
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
		
			var colR = self.entity_collision_line(self.bb_right()+fVX,self.bb_top(),self.bb_right()+fVX,self.bb_bottom()),
				colL = self.entity_collision_line(self.bb_left()+fVX,self.bb_top(),self.bb_left()+fVX,self.bb_bottom());
			if(self.entity_place_collide(sign(fVX),0) && (!self.entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
			{
				var steepness = self.ModifySlopeXSteepness_Up();
				var xnum = 2*sign(fVX);
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveUpSlope_Bottom = (!self.entity_place_collide(xnum,-steepness) && self.entity_place_collide(0,steepness) && self.Crawler_CanMoveUpSlope_Bottom());
				var moveUpSlope_Top = (!self.entity_place_collide(xnum,steepness) && self.entity_place_collide(0,-steepness) && self.Crawler_CanMoveUpSlope_Top());
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
			else if(!self.entity_place_collide(0,0) && colEdge != Edge.Right && colEdge != Edge.Left)
			{
				var steepness = self.ModifySlopeXSteepness_Down();
				var xnum = 2*sign(fVX);
			
				self.DestroyBlock(position.X+xnum,position.Y+steepness);
				self.DestroyBlock(position.X+xnum,position.Y-steepness);
			
				var moveDownSlope_Bottom = (self.entity_place_collide(0,1) && self.entity_place_collide(xnum,steepness) && self.Crawler_CanMoveDownSlope_Bottom());
				var moveDownSlope_Top = (self.entity_place_collide(0,-1) && self.entity_place_collide(xnum,-steepness) && self.Crawler_CanMoveDownSlope_Top());
			
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
		x = scr_round(position.X);
		
		var fVY = self.Crawler_ModifyFinalVelY(min(maxSpeedY,1)*sign(vY));
		if(fVY != 0)
		{
			#region Y Collision
		
			self.DestroyBlock(position.X,position.Y+fVY);
		
			var colB = self.entity_collision_line(self.bb_left(),self.bb_bottom()+fVY,self.bb_right(),self.bb_bottom()+fVY),
				colT = self.entity_collision_line(self.bb_left(),self.bb_top()+fVY,self.bb_right(),self.bb_top()+fVY);
			if(self.entity_place_collide(0,sign(fVY)) && (!self.entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
			{
				var steepness = self.ModifySlopeYSteepness_Up();
				var ynum = 2*sign(fVY);
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveUpSlope_Right = (!self.entity_place_collide(-steepness,ynum) && self.entity_place_collide(steepness,0) && self.Crawler_CanMoveUpSlope_Right());
				var moveUpSlope_Left = (!self.entity_place_collide(steepness,ynum) && self.entity_place_collide(-steepness,0) && self.Crawler_CanMoveUpSlope_Left());
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
			else if(!self.entity_place_collide(0,0) && colEdge != Edge.Bottom && colEdge != Edge.Top)
			{
				var steepness = self.ModifySlopeYSteepness_Down();
				var ynum = 2*sign(fVY);
			
				self.DestroyBlock(position.X+steepness,position.Y+ynum);
				self.DestroyBlock(position.X-steepness,position.Y+ynum);
			
				var moveDownSlope_Right = (self.entity_place_collide(1,0) && self.entity_place_collide(steepness,ynum) && self.Crawler_CanMoveDownSlope_Right());
				var moveDownSlope_Left = (self.entity_place_collide(-1,0) && self.entity_place_collide(-steepness,ynum) && self.Crawler_CanMoveDownSlope_Left());
			
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
function Collision_MovingSolid(vX, vY)
{
	var upSlopeSteepness_X = 5,
		downSlopeSteepness_X = 5,
		upSlopeSteepness_Y = 5,
		downSlopeSteepness_Y = 5;
	
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while(maxSpeedX > 0 || maxSpeedY > 0)
	{
		var fVX = min(maxSpeedX,1)*sign(vX);
		
		#region X Collision
		
		self.DestroyBlock(position.X+fVX,position.Y);
		
		var colR = self.entity_collision_line(self.bb_right()+fVX,self.bb_top(),self.bb_right()+fVX,self.bb_bottom()),
			colL = self.entity_collision_line(self.bb_left()+fVX,self.bb_top(),self.bb_left()+fVX,self.bb_bottom());
		if(self.entity_place_collide(sign(fVX),0) && (!self.entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
		{
			var steepness = upSlopeSteepness_X;
			var xnum = 2*sign(fVX);
			
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
		else if(!self.entity_place_collide(0,0))
		{
			var steepness = downSlopeSteepness_X;
			var xnum = 2*sign(fVX);
			
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
		x = scr_round(position.X);
		
		maxSpeedX = max(maxSpeedX-1,0);
	
	
		var fVY = min(maxSpeedY,1)*sign(vY);
		
		#region Y Collision
		
		self.DestroyBlock(position.X,position.Y+fVY);
		
		var colB = self.entity_collision_line(self.bb_left(),self.bb_bottom()+fVY,self.bb_right(),self.bb_bottom()+fVY),
			colT = self.entity_collision_line(self.bb_left(),self.bb_top()+fVY,self.bb_right(),self.bb_top()+fVY);
		if(self.entity_place_collide(0,sign(fVY)) && (!self.entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
		{
			var steepness = upSlopeSteepness_Y;
			var ynum = 2*sign(fVY);
			
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
		else if(!self.entity_place_collide(0,0))
		{
			var steepness = downSlopeSteepness_Y;
			var ynum = 2*sign(fVY);
			
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
		y = scr_round(position.Y);
		
		maxSpeedY = max(maxSpeedY-1,0);
	}
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


// WIP
npcList = ds_list_create();
#region DamageNPC

function DamageNPC(_colNum, _dmg, _dmgType, _dmgSubType, _freezeType, _freezeMax, _deathType, _invFrames)
{
	///@description scr_DamageNPC
	///@param collision_list_num
	///@param damage
	///@param damageType
	///@param damageSubType
	///@param freezeType
	///@param freezeMax
	///@param deathType
	///@param npcInvFrames
	
	if(_colNum > 0)
	{
		var isProjectile = object_is_ancestor(object_index,obj_Projectile);
		
		for(var i = 0; i < _colNum; i++)
		{
			var npc = npcList[| i];
			if(!instance_exists(npc) || npc.dead || npc.immune)
			{
				continue;
			}
			if(npc.friendly && isProjectile && !hostile)
			{
				continue;
			}
			
			var dmgMult = 0;
			var arrLength = 5;
			if(_dmgType == DmgType.Explosive)
			{
				arrLength = 4;
			}
			for(var d = 1; d <= arrLength; d++)
			{
				if(_dmgSubType[d])
				{
					dmgMult = max(dmgMult, npc.dmgMult[_dmgType][d]);
				}
			}
			dmgMult *= npc.dmgMult[_dmgType][0];
			if(_dmgType == DmgType.Explosive && _dmgSubType[5])
			{
				dmgMult *= npc.dmgMult[_dmgType][5];
			}
			
			_dmg *= dmgMult;
			
			_dmg = npc.ModifyDamageTaken(_dmg,id,isProjectile);
			if(isProjectile)
			{
				_dmg = ModifyDamageNPC(_dmg,npc);
			}
			
			if(isProjectile && !CanDamageNPC(_dmg,npc))
			{
				continue;
			}
			
			var partSys = obj_Particles.partSystemA,
				partEmit = obj_Particles.partEmitA,
				partX1 = posX+(bbox_left-x)+4,
				partX2 = posX+(bbox_right-x)-4,
				partY1 = posY+(bbox_top-y)+4,
				partY2 = posY+(bbox_bottom-y)-4;
			if(isProjectile)
			{
				part_emitter_region(partSys,partEmit,partX1,partX2,partY1,partY2,ps_shape_ellipse,ps_distr_linear);
			}
			
			if(_dmg > 0)
			{
				if(!isProjectile || (npcInvFrames[i] <= 0))// && impacted <= 0))
				{
					var lifeEnd = 0;
					if(!npc.freezeImmune && ((freezeType == 1 && npc.life <= (_dmg*2)) || freezeType == 2))
					{
						if(npc.frozen <= 0)
						{
							lifeEnd = 1;
							audio_stop_sound(snd_FreezeNPC);
							audio_play_sound(snd_FreezeNPC,0,false);
						}
						npc.frozen = freezeMax;
						if(isProjectile)
						{
							part_emitter_burst(partSys,partEmit,obj_Particles.partFreeze,21*(1+isCharge));
							
							if(freezeKill)
							{
								lifeEnd = 0;
							}
						}
					}
					if(npc.frozenInvFrames <= 0)
					{
						if(!npc.freezeImmune && freezeType > 0 && npc.life <= (_dmg*2))
						{
							npc.frozenInvFrames = _invFrames;
						}
						
						npc.StrikeNPC(_dmg, dmgType, dmgSubType, lifeEnd, deathType);
						
						npc.OnDamageTaken(_dmg,id,isProjectile);
						if(isProjectile)
						{
							OnDamageNPC(_dmg,npc);
						}
					}
					if(isProjectile && particleType != -1)
					{
						part_emitter_burst(partSys,partEmit,obj_Particles.bTrails[particleType],7*(1+isCharge));
					}
				}
				if(isProjectile && particleType != -1 && multiHit)
				{
					part_emitter_burst(partSys,partEmit,obj_Particles.bTrails[particleType],(1+isCharge));
				}
			}
			else if(isProjectile)
			{
				if(freezeType > 0 && !npc.freezeImmune)
				{
					if(npc.frozen <= 0)
					{
						audio_stop_sound(snd_FreezeNPC);
						audio_play_sound(snd_FreezeNPC,0,false);
					}
					npc.frozen = freezeMax;
                        
					part_emitter_burst(partSys,partEmit,obj_Particles.partFreeze,21*(1+isCharge));
				}
				else if(dmgType != DmgType.Explosive || !dmgSubType[5])
				{
					if(npc.dmgAbsorb)
					{
						if(impacted <= 0)
						{
							npc.OnDamageAbsorbed(_damage,id,isProjectile);
							
							audio_stop_sound(snd_ProjAbsorbed);
							audio_play_sound(snd_ProjAbsorbed,0,false);
							
							part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partAbsorb,1);
							
							if(!multiHit)
							{
								//instance_destroy();
								impacted = max(impacted,1);
							}
						}
					}
					else if(!reflected || multiHit)
					{
						reflected = true;
						
						audio_stop_sound(snd_Reflect);
						audio_play_sound(snd_Reflect,0,false);
						
						part_emitter_burst(partSys,partEmit,obj_Particles.partDeflect,42);
					}
				}
				
				if(particleType != -1)
				{
					var partAmt = 7*(1+isCharge);
					if(multiHit)
					{
						partAmt = (1+isCharge);
					}
					part_emitter_burst(partSys,partEmit,obj_Particles.bTrails[particleType],partAmt);
				}
			}
			
			if(isProjectile && (_dmg > 0 || !npc.dmgAbsorb))
			{
				if(_dmg > 0 && npcInvFrames[i] <= 0)
				{
					npcInvFrames[i] = _invFrames;
					
					for(var j = 0; j < instance_number(obj_NPC); j++)
					{
						var rlnpc = instance_find(obj_NPC,j);
						if(!instance_exists(rlnpc) || rlnpc.dead || rlnpc.immune)
						{
							continue;
						}
						
						if(rlnpc.realLife == npc)
						{
							npcInvFrames[j] = _invFrames;
						}
						else if(instance_exists(npc.realLife) && rlnpc == npc.realLife)
						{
							npcInvFrames[j] = _invFrames;
							break;
						}
					}
				}
				
				if(!multiHit)
				{
					//instance_destroy();
					impacted = max(impacted,1);
					//damage = 0;
					//break;
				}
			}
			else if(object_index == obj_Player)
			{
				if(IsChargeSomersaulting() && !IsSpeedBoosting() && !IsScrewAttacking() && dmgType == 1 && _dmg > 0)
				{
					statCharge = 0;
				}
			}
		}
	}
}

#endregion