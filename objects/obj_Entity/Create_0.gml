/// @description Initialize

velX = 0; // velocity x
velY = 0; // velocity y
fVelX = 0; // final velocity x
fVelY = 0; // final velocity y

enum Edge
{
	None,
	Bottom,
	Top,
	Left,
	Right
};
colEdge = Edge.Bottom;

grounded = false;

lhc_activate();

#region Base Collision Checks

function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	return lhc_place_meeting(xx+offsetX,yy+offsetY,"ISolid");
}

function entity_position_collide()
{
	/// @description entity_position_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	return lhc_position_meeting(xx+offsetX,yy+offsetY,"ISolid");
}

function entity_collision_line(x1,y1,x2,y2, prec = true, notme = true)
{
	return lhc_collision_line(x1,y1,x2,y2,"ISolid",prec,notme);
}

function GetSlopeAngle(slope)
{
	var ang = 315;
	if(sign(slope.image_yscale) > 0)
	{
		if(sign(slope.image_xscale) > 0)
		{
			ang = 360 - ((45 / slope.image_xscale) * (1 + (1 - 1 / slope.image_yscale)));
		}
		else
		{
			ang = (45 / abs(slope.image_xscale)) * (1 + (1 - 1 / slope.image_yscale));
		}
	}
	else
	{
		if(sign(slope.image_xscale) > 0)
		{
			ang = 180 + ((45 / slope.image_xscale) * (1 + (1 - 1 / abs(slope.image_yscale))));
		}
		else
		{
			ang = 180 - ((45 / abs(slope.image_xscale)) * (1 + (1 - 1 / abs(slope.image_yscale))));
		}
	}
	return ang;
}

#endregion

edgeSlope = ds_list_create();

#region GetEdgeSlope
function GetEdgeSlope()
{
	/// @description GetEdgeSlope
	/// @param edge
	/// @param margin=0
	var edge = argument[0];
	
	var xcheck = 0,
		ycheck = 2;
	switch (edge)
	{
		case Edge.Top:
		{
			xcheck = 0;
			ycheck = -2;
			break;
		}
		case Edge.Left:
		{
			xcheck = -2;
			ycheck = 0;
			break;
		}
		case Edge.Right:
		{
			xcheck = 2;
			ycheck = 0;
			break;
		}
		default:
		{
			break;
		}
	}
	
	var margin = 0;
	if(argument_count > 1)
	{
		margin = argument[1];
	}
		
	var col = instance_place_list(x+xcheck,y+ycheck,all,edgeSlope,true);
	if(col > 0)
	{
		for(var i = 0; i < col; i++)
		{
			if(!instance_exists(edgeSlope[| i]) || !asset_has_any_tag(edgeSlope[| i].object_index,"ISolid",asset_object) || !asset_has_any_tag(edgeSlope[| i].object_index,"ISlope",asset_object))
			{
				continue;
			}
			var slope = edgeSlope[| i];
			if(instance_exists(slope))
			{
				var withinX = (slope.image_xscale > 0 && bbox_left >= slope.bbox_left-margin) || (slope.image_xscale < 0 && bbox_right <= slope.bbox_right+margin),
					withinY = (slope.image_yscale > 0 && bbox_bottom <= slope.bbox_bottom+margin) || (slope.image_yscale < 0 && bbox_top >= slope.bbox_top-margin);
				var checkHor = ((edge == Edge.Bottom && slope.image_yscale > 0) || (edge == Edge.Top && slope.image_yscale < 0)) && withinX,
					checkVer = ((edge == Edge.Left && slope.image_xscale > 0) || (edge == Edge.Right && slope.image_xscale < 0)) && withinY;
				if(checkHor || checkVer)
				{
					ds_list_clear(edgeSlope);
					return slope;
				}
			}
		}
	}
	ds_list_clear(edgeSlope);
	
	return noone;
}
#endregion

#region Collision Hooks

function ModifyFinalVelX(fVX) { return fVX; }
function ModifyFinalVelY(fVY) { return fVY; }

function ModifySlopeXSteepness_Up(steepness) { return steepness; }
function ModifySlopeXSteepness_Down(steepness) { return steepness; }
function ModifySlopeYSteepness_Up(steepness) { return steepness; }
function ModifySlopeYSteepness_Down(steepness) { return steepness; }

// check if slope speed adjustments are applicable
function SlopeCheck(slope)
{
	return (slope.image_yscale > 0 && slope.image_yscale <= 1 && 
	((slope.image_xscale > 0 && bbox_left >= slope.bbox_left) || (slope.image_xscale < 0 && bbox_right <= slope.bbox_right)));
}

// called on horizontal collision
function OnRightCollision(fVX) {} // -->|
function OnLeftCollision(fVX) {} // |<--
function OnXCollision(fVX) {} // same as both above

// check if allowed to move "up" a slope while on the floor, like so:
//	  ->/
//	 - /
//	- /
function CanMoveUpSlope_Bottom() { return true; }
function OnSlopeXCollision_Bottom(fVX) {} // -->/

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
function OnSlopeXCollision_Top(fVX) {} // -->\

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
function OnSlopeYCollision_Right(fVY) {}

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
function OnSlopeYCollision_Left(fVY) {}

// check if allowed to move "down" a slope on the left wall, like so:
//	\ ^
//	 \ |
//	  \ |
function CanMoveDownSlope_Left() { return false; }

//function OnPlatformCollision(fVY) {}

function DestroyBlock(bx,by) {}

#endregion

#region Collision_Normal
function Collision_Normal(vX, vY, vStepX, vStepY, slopeSpeedAdjust)//platformCol, slopeSpeedAdjust)
{
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while((maxSpeedX > 0 && vStepX > 0) || (maxSpeedY > 0 && vStepY > 0))
	{
		var vX2 = min(maxSpeedX,vStepX)*sign(vX);
		
		var sAngle = 0;
		var slope = GetEdgeSlope(Edge.Bottom);
		if(instance_exists(slope) && slopeSpeedAdjust)
		{
			if(SlopeCheck(slope))
			{
				sAngle = GetSlopeAngle(slope);
			}
		}
		
		var fVX = lengthdir_x(vX2,sAngle);
		fVX = ModifyFinalVelX(fVX);
		
		#region X Collision
		
		DestroyBlock(x+fVX,y);
		
		var yplusMax = vStepX+1;
		
		var colR = entity_collision_line(bbox_right+fVX,bbox_top,bbox_right+fVX,bbox_bottom),
			colL = entity_collision_line(bbox_left+fVX,bbox_top,bbox_left+fVX,bbox_bottom);
		var xspeed = abs(fVX);
		if(entity_place_collide(max(abs(fVX),1)*sign(fVX),0) && (!entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
		{
			var steepness = ModifySlopeXSteepness_Up(3);
			
			var yplus = 0;
			while(entity_place_collide(fVX,yplus) && yplus >= -yplusMax)
			{
				yplus--;
				DestroyBlock(x+sign(fVX),y+min(yplus,-steepness));
				DestroyBlock(x+fVX+sign(fVX),y+min(yplus,-steepness));
			}
			while(entity_place_collide(fVX,yplus) && yplus <= yplusMax)
			{
				yplus++;
				DestroyBlock(x+sign(fVX),y+max(yplus,steepness));
				DestroyBlock(x+fVX+sign(fVX),y+max(yplus,steepness));
			}
			
			var xnum = 0;
			while(!entity_place_collide(xnum*sign(fVX),0) && xnum <= xspeed)
			{
				xnum++;
			}
			
			var slopeFlag_B = (!entity_place_collide((xnum+1)*sign(fVX),-steepness) && entity_place_collide((xnum-1)*sign(fVX),steepness));
			var moveUpSlope_Bottom = (slopeFlag_B && CanMoveUpSlope_Bottom());
			var slopeFlag_T = (!entity_place_collide((xnum+1)*sign(fVX),steepness) && entity_place_collide((xnum-1)*sign(fVX),-steepness));
			var moveUpSlope_Top = (slopeFlag_T && CanMoveUpSlope_Top());
			
			if(entity_place_collide(fVX,yplus) || (!moveUpSlope_Bottom && !moveUpSlope_Top))
			{
				if(fVX > 0)
				{
					OnRightCollision(fVX);
					x = scr_floor(x);
				}
				if(fVX < 0)
				{
					OnLeftCollision(fVX);
					x = scr_ceil(x);
				}
				var xnum2 = xspeed+2;
				while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
				{
					x += sign(fVX);
					xnum2--;
				}
				OnXCollision(fVX);
				fVX = 0;
				maxSpeedX = 0;
			}
			else
			{
				if(yplus > 0)
				{
					OnSlopeXCollision_Top(fVX);
					y = floor(y + yplus);
					if(entity_place_collide(fVX,0))
					{
						y += 1;
					}
				}
				else
				{
					OnSlopeXCollision_Bottom(fVX);
					y = ceil(y + yplus);
					if(entity_place_collide(fVX,0))
					{
						y -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0))
		{
			var steepness = ModifySlopeXSteepness_Down(4);
			
			DestroyBlock(x+fVX+sign(fVX),y+min(abs(fVX),steepness+2));
			DestroyBlock(x+fVX+sign(fVX),y-min(abs(fVX),steepness+2));
			
			var xnum3 = 0;
			while(entity_place_collide(xnum3*sign(fVX),1) && xnum3 <= xspeed)
			{
				xnum3++;
			}
			var xnum4 = 0;
			while(entity_place_collide(xnum4*sign(fVX),-1) && xnum4 <= xspeed)
			{
				xnum4++;
			}
			
			var moveDownSlope_Bottom = (entity_place_collide(xnum3*sign(fVX)+sign(fVX),steepness) && CanMoveDownSlope_Bottom());
			var moveDownSlope_Top = (entity_place_collide(xnum4*sign(fVX)+sign(fVX),-steepness) && CanMoveDownSlope_Top());
			
			if(moveDownSlope_Bottom || moveDownSlope_Top)
			{
				var yplus2 = 0;
				if(moveDownSlope_Bottom)
				{
					while(!entity_place_collide(fVX,yplus2+1) && yplus2 <= yplusMax)
					{
						yplus2++;
					}
				}
				if(moveDownSlope_Top)
				{
					while(!entity_place_collide(fVX,yplus2-1) && yplus2 >= -yplusMax)
					{
						yplus2--;
					}
				}
					
				DestroyBlock(x+fVX,y+yplus2+sign(yplus2));
			
				if(!entity_place_collide(fVX,yplus2))
				{
					if(entity_place_collide(fVX,yplus2+sign(yplus2)))
					{
						if(yplus2 > 0)
						{
							y = ceil(y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								y -= 1;
							}
						}
						else
						{
							y = floor(y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								y += 1;
							}
						}
					}
				}
			}
		}
		#endregion
		
		x += fVX;
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
	
	
		var vY2 = min(maxSpeedY,vStepY)*sign(vY);
		
		var left_rot = 270,
			right_rot = 90;
		
		var sAngle2 = 0;
		slope = GetEdgeSlope(Edge.Right);
		if(!instance_exists(slope))
		{
			slope = GetEdgeSlope(Edge.Left);
		}
		if(instance_exists(slope) && slopeSpeedAdjust)
		{
			sAngle = left_rot;
			if(slope.image_xscale < 0)
			{
				sAngle = right_rot;
			}
			if(Crawler_SlopeCheck(slope))
			{
				sAngle2 = angle_difference(GetSlopeAngle(slope),sAngle);
			}
		}
		
		var fVY = lengthdir_x(vY2,sAngle2);
		fVY = ModifyFinalVelY(fVY);
		
		#region Y Collision
		
		DestroyBlock(x,y+fVY);
		
		var xplusMax = vStepY+1;
		
		var colB = entity_collision_line(bbox_left,bbox_bottom+fVY,bbox_right,bbox_bottom+fVY),
			colT = entity_collision_line(bbox_left,bbox_top+fVY,bbox_right,bbox_top+fVY);
		var yspeed = abs(fVY);
		if(entity_place_collide(0,max(abs(fVY),1)*sign(fVY)) && (!entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
		{
			var steepness = ModifySlopeYSteepness_Up(3);
			
			var xplus = 0;
			while(entity_place_collide(xplus,fVY) && xplus >= -xplusMax)
			{
				xplus--;
				DestroyBlock(x+min(xplus,-steepness),y+sign(fVY));
				DestroyBlock(x+min(xplus,-steepness),y+fVY+sign(fVY));
			}
			while(entity_place_collide(xplus,fVY) && xplus <= xplusMax)
			{
				xplus++;
				DestroyBlock(x+max(xplus,steepness),y+sign(fVY));
				DestroyBlock(x+max(xplus,steepness),y+fVY+sign(fVY));
			}
			
			var ynum = 0;
			while(!entity_place_collide(0,ynum*sign(fVY)) && ynum <= yspeed)
			{
				ynum++;
			}
			
			var slopeFlag_R = (!entity_place_collide(-steepness,(ynum+1)*sign(fVY)) && entity_place_collide(steepness,(ynum-1)*sign(fVY)));
			var moveUpSlope_Right = (slopeFlag_R && CanMoveUpSlope_Right());
			var slopeFlag_L = (!entity_place_collide(steepness,(ynum+1)*sign(fVY)) && entity_place_collide(-steepness,(ynum-1)*sign(fVY)));
			var moveUpSlope_Left = (slopeFlag_L && CanMoveUpSlope_Left());
			
			if(entity_place_collide(xplus,fVY) || (!moveUpSlope_Right && !moveUpSlope_Left))
			{
				if(fVY > 0)
				{
					OnBottomCollision(fVY);
					y = scr_floor(y);
				}
				if(fVY < 0)
				{
					OnTopCollision(fVY);
					y = scr_ceil(y);
				}
				var ynum2 = yspeed+2;
				while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
				{
					y += sign(fVY);
					ynum2--;
				}
				OnYCollision(fVY);
				fVY = 0;
				maxSpeedY = 0;
			}
			else
			{
				if(xplus > 0)
				{
					OnSlopeYCollision_Left(fVY);
					x = floor(x + xplus);
					if(entity_place_collide(0,fVY))
					{
						x += 1;
					}
				}
				else
				{
					OnSlopeYCollision_Right(fVY);
					x = ceil(x + xplus);
					if(entity_place_collide(0,fVY))
					{
						x -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0))
		{
			var steepness = ModifySlopeYSteepness_Down(4);
			
			DestroyBlock(x+min(abs(fVY),steepness+2),y+fVY+sign(fVY));
			DestroyBlock(x-min(abs(fVY),steepness+2),y+fVY+sign(fVY));
			
			var ynum3 = 0;
			while(entity_place_collide(1,ynum3*sign(fVY)) && ynum3 <= yspeed)
			{
				ynum3++;
			}
			var ynum4 = 0;
			while(entity_place_collide(-1,ynum4*sign(fVY)) && ynum4 <= yspeed)
			{
				ynum4++;
			}
			
			var moveDownSlope_Right = (entity_place_collide(steepness,ynum3*sign(fVY)+sign(fVY)) && CanMoveDownSlope_Right());
			var moveDownSlope_Left = (entity_place_collide(-steepness,ynum4*sign(fVY)+sign(fVY)) && CanMoveDownSlope_Left());
			
			if(moveDownSlope_Right || moveDownSlope_Left)
			{
				var xplus2 = 0;
				if(moveDownSlope_Right)
				{
					while(!entity_place_collide(1+xplus2,fVY) && xplus2 <= xplusMax)
					{
						xplus2++;
					}
				}
				if(moveDownSlope_Left)
				{
					while(!entity_place_collide(-1+xplus2,fVY) && xplus2 >= -xplusMax)
					{
						xplus2--;
					}
				}
					
				DestroyBlock(x+xplus2+sign(xplus2),y+fVY);
			
				if(!entity_place_collide(xplus2,fVY))
				{
					if(entity_place_collide(xplus2+sign(xplus2),fVY))
					{
						if(xplus2 > 0)
						{
							x = ceil(x + xplus2);
							if(entity_place_collide(0,fVY))
							{
								x -= 1;
							}
						}
						else
						{
							x = floor(x + xplus2);
							if(entity_place_collide(0,fVY))
							{
								x += 1;
							}
						}
					}
				}
			}
		}
		
		#endregion
		
		y += fVY;
		
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
}
#endregion

#region Crawler Collision Hooks

function Crawler_ModifyFinalVelX(fVX) { return fVX; }
function Crawler_ModifyFinalVelY(fVY) { return fVY; }

// check if slope speed adjustments are applicable
function Crawler_SlopeCheck(slope)
{
	return colEdge != Edge.None;
}

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
function Crawler_OnSlopeXCollision_Bottom(fVX) // -->/
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
function Crawler_OnSlopeXCollision_Top(fVX) // -->\
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
	return (colEdge == Edge.Right);
}
function Crawler_OnSlopeYCollision_Right(fVY)
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
	return (colEdge == Edge.Left);
}
function Crawler_OnSlopeYCollision_Left(fVY)
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

function Crawler_DestroyBlock(bx,by) {}

#endregion

#region Collision_Crawler
function Collision_Crawler(vX, vY, vStepX, vStepY, slopeSpeedAdjust)//platformCol, slopeSpeedAdjust)
{
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while((maxSpeedX > 0 && vStepX > 0) || (maxSpeedY > 0 && vStepY > 0))
	{
		var vX2 = min(maxSpeedX,vStepX)*sign(vX);
		
		var sAngle = 0;
		var bottom_rot = 0,
			left_rot = 270,
			top_rot = 180,
			right_rot = 90;
		switch(colEdge)
		{
			case Edge.Bottom:
			{
				sAngle = bottom_rot;
				break;
			}
			case Edge.Left:
			{
				sAngle = left_rot;
				break;
			}
			case Edge.Top:
			{
				sAngle = top_rot;
				break;
			}
			case Edge.Right:
			{
				sAngle = right_rot;
				break;
			}
		}
		
		var sAngle2 = 0;
		var slope = GetEdgeSlope(colEdge);
		if(instance_exists(slope) && slopeSpeedAdjust)
		{
			if(Crawler_SlopeCheck(slope))
			{
				sAngle2 = angle_difference(GetSlopeAngle(slope),sAngle);
			}
		}
		
		var fVX = lengthdir_x(vX2,sAngle2);
		fVX = Crawler_ModifyFinalVelX(fVX);
		
		#region X Collision
		
		Crawler_DestroyBlock(x+fVX,y);
		
		var yplusMax = vStepX+1;
		
		var colR = entity_collision_line(bbox_right+fVX,bbox_top,bbox_right+fVX,bbox_bottom),
			colL = entity_collision_line(bbox_left+fVX,bbox_top,bbox_left+fVX,bbox_bottom);
		var xspeed = abs(fVX);
		if(entity_place_collide(max(abs(fVX),1)*sign(fVX),0) && (!entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
		{
			var steepness = 3;
			
			var yplus = 0;
			while(entity_place_collide(fVX,yplus) && yplus >= -yplusMax)
			{
				yplus--;
				Crawler_DestroyBlock(x+sign(fVX),y+min(yplus,-steepness));
				Crawler_DestroyBlock(x+fVX+sign(fVX),y+min(yplus,-steepness));
			}
			while(entity_place_collide(fVX,yplus) && yplus <= yplusMax)
			{
				yplus++;
				Crawler_DestroyBlock(x+sign(fVX),y+max(yplus,steepness));
				Crawler_DestroyBlock(x+fVX+sign(fVX),y+max(yplus,steepness));
			}
			
			var xnum = 0;
			while(!entity_place_collide(xnum*sign(fVX),0) && xnum <= xspeed)
			{
				xnum++;
			}
			
			var moveUpSlope_Bottom = (!entity_place_collide(xnum*sign(fVX)+sign(fVX),-steepness) && Crawler_CanMoveUpSlope_Bottom());
			var moveUpSlope_Top = (!entity_place_collide(xnum*sign(fVX)+sign(fVX),steepness) && Crawler_CanMoveUpSlope_Top());
			var horizontalEdge = (colEdge == Edge.Bottom || colEdge == Edge.Top);
			
			if(entity_place_collide(fVX,yplus) || (!moveUpSlope_Bottom && !moveUpSlope_Top) || (!horizontalEdge && colEdge != Edge.None))
			{
				if(fVX > 0)
				{
					Crawler_OnRightCollision(fVX);
					if(horizontalEdge || colEdge == Edge.None)
					{
						if(horizontalEdge)
						{
							vY *= -1;
						}
						colEdge = Edge.Right;
					}
					x = scr_floor(x);
				}
				if(fVX < 0)
				{
					Crawler_OnLeftCollision(fVX);
					if(horizontalEdge || colEdge == Edge.None)
					{
						if(horizontalEdge)
						{
							vY *= -1;
						}
						colEdge = Edge.Left;
					}
					x = scr_ceil(x);
				}
				var xnum2 = xspeed+2;
				while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
				{
					x += sign(fVX);
					xnum2--;
				}
				Crawler_OnXCollision(fVX);
				fVX = 0;
				maxSpeedX = 0;
			}
			else
			{
				if(yplus > 0)
				{
					Crawler_OnSlopeXCollision_Top(fVX);
					y = floor(y + yplus);
					if(entity_place_collide(fVX,0))
					{
						y += 1;
					}
				}
				else
				{
					Crawler_OnSlopeXCollision_Bottom(fVX);
					y = ceil(y + yplus);
					if(entity_place_collide(fVX,0))
					{
						y -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && (colEdge == Edge.Bottom || colEdge == Edge.Top))
		{
			var steepness = 3;
			
			Crawler_DestroyBlock(x+fVX+sign(fVX),y+min(abs(fVX),steepness+2));
			Crawler_DestroyBlock(x+fVX+sign(fVX),y-min(abs(fVX),steepness+2));
			
			var ydir = 1;
			if(colEdge == Edge.Top)
			{
				ydir = -1;
			}
			
			var xnum3 = 0;
			while(entity_place_collide(xnum3*sign(fVX),1) && xnum3 <= xspeed)
			{
				xnum3++;
			}
			var xnum4 = 0;
			while(entity_place_collide(xnum4*sign(fVX),-1) && xnum4 <= xspeed)
			{
				xnum4++;
			}
			
			var moveDownSlope_Bottom = (entity_place_collide(xnum3*sign(fVX)+sign(fVX),steepness) && Crawler_CanMoveDownSlope_Bottom());
			var moveDownSlope_Top = (entity_place_collide(xnum4*sign(fVX)+sign(fVX),-steepness) && Crawler_CanMoveDownSlope_Top());
			
			if(moveDownSlope_Bottom || moveDownSlope_Top)
			{
				var yplus2 = 0;
				if(moveDownSlope_Bottom)
				{
					while(!entity_place_collide(fVX,1+yplus2) && yplus2 <= yplusMax)
					{
						yplus2++;
					}
				}
				if(moveDownSlope_Top)
				{
					while(!entity_place_collide(fVX,-1+yplus2) && yplus2 >= -yplusMax)
					{
						yplus2--;
					}
				}
					
				Crawler_DestroyBlock(x+fVX,y+yplus2+sign(yplus2));
			
				if(!entity_place_collide(fVX,yplus2))
				{
					if(entity_place_collide(fVX,yplus2+sign(yplus2)))
					{
						if(yplus2 > 0)
						{
							y = ceil(y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								y -= 1;
							}
						}
						else
						{
							y = floor(y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								y += 1;
							}
						}
					}
				}
			}
			else
			{
				if(fVX > 0)
				{
					x = scr_floor(x);
					colEdge = Edge.Left;
				}
				if(fVX < 0)
				{
					x = scr_ceil(x);
					colEdge = Edge.Right;
				}
				var xnum2 = xspeed+2;
				while(entity_place_collide(0,ydir) && xnum2 > 0)
				{
					x += sign(fVX);
					xnum2--;
				}
				if(!entity_place_collide(0,ydir))
				{
					y += ydir;
				}
				
				vX *= -1;
				fVX = 0;
				maxSpeedX = 0;
			}
		}
		
		#endregion
		
		x += fVX;
		
		
		var vY2 = min(maxSpeedY,vStepY)*sign(vY);
		var fVY = lengthdir_x(vY2,sAngle2);
		fVY = Crawler_ModifyFinalVelY(fVY);
		
		#region Y Collision
		
		Crawler_DestroyBlock(x,y+fVY);
		
		var xplusMax = vStepY+1;
		
		var colB = entity_collision_line(bbox_left,bbox_bottom+fVY,bbox_right,bbox_bottom+fVY),
			colT = entity_collision_line(bbox_left,bbox_top+fVY,bbox_right,bbox_top+fVY);
		var yspeed = abs(fVY);
		if(entity_place_collide(0,max(abs(fVY),1)*sign(fVY)) && (!entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
		{
			var steepness = 3;
			
			var xplus = 0;
			while(entity_place_collide(xplus,fVY) && xplus >= -xplusMax)
			{
				xplus--;
				Crawler_DestroyBlock(x+min(xplus,-steepness),y+sign(fVY));
				Crawler_DestroyBlock(x+min(xplus,-steepness),y+fVY+sign(fVY));
			}
			while(entity_place_collide(xplus,fVY) && xplus <= xplusMax)
			{
				xplus++;
				Crawler_DestroyBlock(x+max(xplus,steepness),y+sign(fVY));
				Crawler_DestroyBlock(x+max(xplus,steepness),y+fVY+sign(fVY));
			}
			
			var ynum = 0;
			while(!entity_place_collide(0,ynum*sign(fVY)) && ynum <= yspeed)
			{
				ynum++;
			}
			
			var moveUpSlope_Right = (!entity_place_collide(-steepness,ynum*sign(fVY)+sign(fVY)) && Crawler_CanMoveUpSlope_Right());
			var moveUpSlope_Left = (!entity_place_collide(steepness,ynum*sign(fVY)+sign(fVY)) && Crawler_CanMoveUpSlope_Left());
			var verticalEdge = (colEdge == Edge.Left || colEdge == Edge.Right);
			
			if(entity_place_collide(xplus,fVY) || (!moveUpSlope_Right && !moveUpSlope_Left) || (!verticalEdge && colEdge != Edge.None))
			{
				if(fVY > 0)
				{
					Crawler_OnBottomCollision(fVY);
					if(verticalEdge || colEdge == Edge.None)
					{
						if(verticalEdge)
						{
							vX *= -1;
						}
						colEdge = Edge.Bottom;
					}
					y = scr_floor(y);
				}
				if(fVY < 0)
				{
					Crawler_OnTopCollision(fVY);
					if(verticalEdge || colEdge == Edge.None)
					{
						if(verticalEdge)
						{
							vX *= -1;
						}
						colEdge = Edge.Top;
					}
					y = scr_ceil(y);
				}
				var ynum2 = yspeed+2;
				while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
				{
					y += sign(fVY);
					ynum2--;
				}
				Crawler_OnYCollision(fVY);
				fVY = 0;
				maxSpeedY = 0;
			}
			else
			{
				if(xplus > 0)
				{
					Crawler_OnSlopeYCollision_Left(fVY);
					x = floor(x + xplus);
					if(entity_place_collide(0,fVY))
					{
						x += 1;
					}
				}
				else
				{
					Crawler_OnSlopeYCollision_Right(fVY);
					x = ceil(x + xplus);
					if(entity_place_collide(0,fVY))
					{
						x -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && (colEdge == Edge.Left || colEdge == Edge.Right))
		{
			var steepness = 3;
			
			Crawler_DestroyBlock(x+min(abs(fVY),steepness+2),y+fVY+sign(fVY));
			Crawler_DestroyBlock(x-min(abs(fVY),steepness+2),y+fVY+sign(fVY));
			
			var xdir = 1;
			if(colEdge == Edge.Left)
			{
				xdir = -1;
			}
			
			var ynum3 = 0;
			while(entity_place_collide(1,ynum3*sign(fVY)) && ynum3 <= yspeed)
			{
				ynum3++;
			}
			var ynum4 = 0;
			while(entity_place_collide(-1,ynum4*sign(fVY)) && ynum4 <= yspeed)
			{
				ynum4++;
			}
			
			var moveDownSlope_Right = (entity_place_collide(steepness,ynum3*sign(fVY)+sign(fVY)) && Crawler_CanMoveDownSlope_Right());
			var moveDownSlope_Left = (entity_place_collide(-steepness,ynum4*sign(fVY)+sign(fVY)) && Crawler_CanMoveDownSlope_Left());
			
			if(moveDownSlope_Right || moveDownSlope_Left)
			{
				var xplus2 = 0;
				if(moveDownSlope_Right && colEdge == Edge.Right)
				{
					while(!entity_place_collide(1+xplus2,fVY) && xplus2 <= xplusMax)
					{
						xplus2++;
					}
				}
				if(moveDownSlope_Left && colEdge == Edge.Left)
				{
					while(!entity_place_collide(-1+xplus2,fVY) && xplus2 >= -xplusMax)
					{
						xplus2--;
					}
				}
					
				Crawler_DestroyBlock(x+xplus2+sign(xplus2),y+fVY);
			
				if(!entity_place_collide(xplus2,fVY))
				{
					if(entity_place_collide(xplus2+sign(xplus2),fVY))
					{
						if(xplus2 > 0)
						{
							x = ceil(x + xplus2);
							if(entity_place_collide(0,fVY))
							{
								x -= 1;
							}
						}
						else
						{
							x = floor(x + xplus2);
							if(entity_place_collide(0,fVY))
							{
								x += 1;
							}
						}
					}
				}
			}
			else
			{
				if(fVY > 0)
				{
					y = scr_floor(y);
					colEdge = Edge.Top;
				}
				if(fVY < 0)
				{
					y = scr_ceil(y);
					colEdge = Edge.Bottom;
				}
				var ynum2 = yspeed+2;
				while(entity_place_collide(xdir,0) && ynum2 > 0)
				{
					y += sign(fVY);
					ynum2--;
				}
				if(!entity_place_collide(xdir,0))
				{
					x += xdir;
				}
				
				vY *= -1;
				fVY = 0;
				maxSpeedY = 0;
			}
		}
		
		#endregion
		
		y += fVY;
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
}
#endregion


#region Collision_Basic

function Collision_Basic(vX, vY, vStepX, vStepY, upSlopeSteepness_X = 5, downSlopeSteepness_X = 5, upSlopeSteepness_Y = 0, downSlopeSteepness_Y = 0)
{
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while((maxSpeedX > 0 && vStepX > 0) || (maxSpeedY > 0 && vStepY > 0))
	{
		var fVX = min(maxSpeedX,vStepX)*sign(vX);
		
		#region X Collision
		
		DestroyBlock(x+fVX,y);
		
		var yplusMax = vStepX+1;
		
		var colR = entity_collision_line(bbox_right+fVX,bbox_top,bbox_right+fVX,bbox_bottom),
			colL = entity_collision_line(bbox_left+fVX,bbox_top,bbox_left+fVX,bbox_bottom);
		var xspeed = abs(fVX);
		if(entity_place_collide(max(abs(fVX),1)*sign(fVX),0) && (!entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
		{
			var steepness = upSlopeSteepness_X;
			
			var yplus = 0;
			while(entity_place_collide(fVX,yplus) && yplus >= -yplusMax)
			{
				yplus--;
				DestroyBlock(x+sign(fVX),y+min(yplus,-steepness));
				DestroyBlock(x+fVX+sign(fVX),y+min(yplus,-steepness));
			}
			while(entity_place_collide(fVX,yplus) && yplus <= yplusMax)
			{
				yplus++;
				DestroyBlock(x+sign(fVX),y+max(yplus,steepness));
				DestroyBlock(x+fVX+sign(fVX),y+max(yplus,steepness));
			}
			
			var xnum = 0;
			while(!entity_place_collide(xnum*sign(fVX),0) && xnum <= xspeed)
			{
				xnum++;
			}
			
			var moveUpSlope_Bottom = (!entity_place_collide((xnum+1)*sign(fVX),-steepness) && entity_place_collide((xnum-1)*sign(fVX),steepness) && steepness > 0);
			var moveUpSlope_Top = (!entity_place_collide((xnum+1)*sign(fVX),steepness) && entity_place_collide((xnum-1)*sign(fVX),-steepness) && steepness > 0);
			
			if(entity_place_collide(fVX,yplus) || (!moveUpSlope_Bottom && !moveUpSlope_Top))
			{
				if(fVX > 0)
				{
					x = scr_floor(x);
				}
				if(fVX < 0)
				{
					x = scr_ceil(x);
				}
				var xnum2 = xspeed+2;
				while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
				{
					x += sign(fVX);
					xnum2--;
				}
				fVX = 0;
				maxSpeedX = 0;
			}
			else
			{
				if(yplus > 0)
				{
					y = floor(y + yplus);
					if(entity_place_collide(fVX,0))
					{
						y += 1;
					}
				}
				else
				{
					y = ceil(y + yplus);
					if(entity_place_collide(fVX,0))
					{
						y -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && downSlopeSteepness_X > 0)
		{
			var steepness = downSlopeSteepness_X;
			
			DestroyBlock(x+fVX+sign(fVX),y+min(abs(fVX),steepness+2));
			DestroyBlock(x+fVX+sign(fVX),y-min(abs(fVX),steepness+2));
			
			var xnum3 = 0;
			while(entity_place_collide(xnum3*sign(fVX),1) && xnum3 <= xspeed)
			{
				xnum3++;
			}
			var xnum4 = 0;
			while(entity_place_collide(xnum4*sign(fVX),-1) && xnum4 <= xspeed)
			{
				xnum4++;
			}
			
			var moveDownSlope_Bottom = (entity_place_collide(xnum3*sign(fVX)+sign(fVX),steepness));
			var moveDownSlope_Top = (entity_place_collide(xnum4*sign(fVX)+sign(fVX),-steepness));
			
			if(moveDownSlope_Bottom || moveDownSlope_Top)
			{
				var yplus2 = 0;
				if(moveDownSlope_Bottom)
				{
					while(!entity_place_collide(fVX,yplus2+1) && yplus2 <= yplusMax)
					{
						yplus2++;
					}
				}
				if(moveDownSlope_Top)
				{
					while(!entity_place_collide(fVX,yplus2-1) && yplus2 >= -yplusMax)
					{
						yplus2--;
					}
				}
					
				DestroyBlock(x+fVX,y+yplus2+sign(yplus2));
			
				if(!entity_place_collide(fVX,yplus2))
				{
					if(entity_place_collide(fVX,yplus2+sign(yplus2)))
					{
						if(yplus2 > 0)
						{
							y = ceil(y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								y -= 1;
							}
						}
						else
						{
							y = floor(y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								y += 1;
							}
						}
					}
				}
			}
		}
		#endregion
		
		x += fVX;
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
	
	
		var fVY = min(maxSpeedY,vStepY)*sign(vY);
		
		#region Y Collision
		
		DestroyBlock(x,y+fVY);
		
		var xplusMax = vStepY+1;
		
		var colB = entity_collision_line(bbox_left,bbox_bottom+fVY,bbox_right,bbox_bottom+fVY),
			colT = entity_collision_line(bbox_left,bbox_top+fVY,bbox_right,bbox_top+fVY);
		var yspeed = abs(fVY);
		if(entity_place_collide(0,max(abs(fVY),1)*sign(fVY)) && (!entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
		{
			var steepness = upSlopeSteepness_Y;
			
			var xplus = 0;
			while(entity_place_collide(xplus,fVY) && xplus >= -xplusMax)
			{
				xplus--;
				DestroyBlock(x+min(xplus,-steepness),y+sign(fVY));
				DestroyBlock(x+min(xplus,-steepness),y+fVY+sign(fVY));
			}
			while(entity_place_collide(xplus,fVY) && xplus <= xplusMax)
			{
				xplus++;
				DestroyBlock(x+max(xplus,steepness),y+sign(fVY));
				DestroyBlock(x+max(xplus,steepness),y+fVY+sign(fVY));
			}
			
			var ynum = 0;
			while(!entity_place_collide(0,ynum*sign(fVY)) && ynum <= yspeed)
			{
				ynum++;
			}
			
			var moveUpSlope_Right = (!entity_place_collide(-steepness,(ynum+1)*sign(fVY)) && entity_place_collide(steepness,(ynum-1)*sign(fVY)) && steepness > 0);
			var moveUpSlope_Left = (!entity_place_collide(steepness,(ynum+1)*sign(fVY)) && entity_place_collide(-steepness,(ynum-1)*sign(fVY)) && steepness > 0);
			
			if(entity_place_collide(xplus,fVY) || (!moveUpSlope_Right && !moveUpSlope_Left))
			{
				if(fVY > 0)
				{
					y = scr_floor(y);
				}
				if(fVY < 0)
				{
					y = scr_ceil(y);
				}
				var ynum2 = yspeed+2;
				while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
				{
					y += sign(fVY);
					ynum2--;
				}
				fVY = 0;
				maxSpeedY = 0;
			}
			else
			{
				if(xplus > 0)
				{
					x = floor(x + xplus);
					if(entity_place_collide(0,fVY))
					{
						x += 1;
					}
				}
				else
				{
					x = ceil(x + xplus);
					if(entity_place_collide(0,fVY))
					{
						x -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && downSlopeSteepness_Y > 0)
		{
			var steepness = downSlopeSteepness_Y;
			
			DestroyBlock(x+min(abs(fVY),steepness+2),y+fVY+sign(fVY));
			DestroyBlock(x-min(abs(fVY),steepness+2),y+fVY+sign(fVY));
			
			var ynum3 = 0;
			while(entity_place_collide(1,ynum3*sign(fVY)) && ynum3 <= yspeed)
			{
				ynum3++;
			}
			var ynum4 = 0;
			while(entity_place_collide(-1,ynum4*sign(fVY)) && ynum4 <= yspeed)
			{
				ynum4++;
			}
			
			var moveDownSlope_Right = (entity_place_collide(steepness,ynum3*sign(fVY)+sign(fVY)));
			var moveDownSlope_Left = (entity_place_collide(-steepness,ynum4*sign(fVY)+sign(fVY)));
			
			if(moveDownSlope_Right || moveDownSlope_Left)
			{
				var xplus2 = 0;
				if(moveDownSlope_Right)
				{
					while(!entity_place_collide(1+xplus2,fVY) && xplus2 <= xplusMax)
					{
						xplus2++;
					}
				}
				if(moveDownSlope_Left)
				{
					while(!entity_place_collide(-1+xplus2,fVY) && xplus2 >= -xplusMax)
					{
						xplus2--;
					}
				}
					
				DestroyBlock(x+xplus2+sign(xplus2),y+fVY);
			
				if(!entity_place_collide(xplus2,fVY))
				{
					if(entity_place_collide(xplus2+sign(xplus2),fVY))
					{
						if(xplus2 > 0)
						{
							x = ceil(x + xplus2);
							if(entity_place_collide(0,fVY))
							{
								x -= 1;
							}
						}
						else
						{
							x = floor(x + xplus2);
							if(entity_place_collide(0,fVY))
							{
								x += 1;
							}
						}
					}
				}
			}
		}
		
		#endregion
		
		y += fVY;
		
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
}

/*function Collision_Basic(vX, vY, vStepX, vStepY)
{
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while(maxSpeedX > 0 && vStepX > 0) || (maxSpeedY > 0 && vStepY > 0)
	{
		var fVX = min(maxSpeedX,vStepX)*sign(vX);
		
		#region X Collision
		
		DestroyBlock(x+fVX,y);
		
		var colR = entity_collision_line(bbox_right+fVX,bbox_top,bbox_right+fVX,bbox_bottom),
			colL = entity_collision_line(bbox_left+fVX,bbox_top,bbox_left+fVX,bbox_bottom);
		var xspeed = abs(fVX);
		if(entity_place_collide(fVX,0) && (!entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
		{
			if(fVX > 0)
			{
				//OnRightCollision(fVX);
				x = scr_floor(x);
			}
			if(fVX < 0)
			{
				//OnLeftCollision(fVX);
				x = scr_ceil(x);
			}
			var xnum2 = xspeed+2;
			while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
			{
				x += sign(fVX);
				xnum2--;
			}
			//OnXCollision(fVX);
			fVX = 0;
			maxSpeedX = 0;
		}
		
		#endregion
		
		x += fVX;
		
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
	
	
	
		var fVY = min(maxSpeedY,vStepY)*sign(vY);
		
		#region Y Collision
		
		DestroyBlock(x,y+fVY);
		
		var colB = entity_collision_line(bbox_left,bbox_bottom+fVY,bbox_right,bbox_bottom+fVY),
			colT = entity_collision_line(bbox_left,bbox_top+fVY,bbox_right,bbox_top+fVY);
		var yspeed = abs(fVY);
		if(entity_place_collide(0,fVY) && (!entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
		{
			if(fVY > 0)
			{
				//OnBottomCollision(fVY);
				y = scr_floor(y);
			}
			if(fVY < 0)
			{
				//OnTopCollision(fVY);
				y = scr_ceil(y);
			}
			var ynum2 = yspeed+2;
			while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
			{
				y += sign(fVY);
				ynum2--;
			}
			//OnYCollision(fVY);
			fVY = 0;
			maxSpeedY = 0;
		}
		
		#endregion
		
		y += fVY;
		
		
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
}*/
#endregion


#region scr_BreakBlock
function scr_BreakBlock(xx,yy,type)
{
	if(place_meeting(xx,yy,obj_Breakable) && type > -1)
	{
		scr_DestroyObject(xx,yy,obj_ShotBlock);
	
		/*if(place_meeting(xx,yy,obj_BombBlock) && type == 0 && object_is_ancestor(object_index,obj_Projectile) && object_index.isBeam)
		{
		    var b = instance_place(xx,yy,obj_BombBlock);
		    if(!b.visible)
		    {
		        b.revealTile = true;
		    }
		}*/
	
		if(type == 1 || type >= 4)
		{
		    scr_DestroyObject(xx,yy,obj_BombBlock);

		    if(type == 1 || type == 7)
		    {
		        scr_DestroyObject(xx,yy,obj_ChainBlock);
		    }
		}

		if(type == 2 || type == 3 || type == 7)
		{
		    scr_DestroyObject(xx,yy,obj_MissileBlock);
		}

		if(type == 3 || type == 7)
		{
		    scr_DestroyObject(xx,yy,obj_SuperMissileBlock);
		}

		if(type == 4 || type == 7)
		{
		    scr_DestroyObject(xx,yy,obj_PowerBombBlock);
		}

		if(type == 5 || type == 7)
		{
		    scr_DestroyObject(xx,yy,obj_SpeedBlock);
		}

		if(type == 6 || type == 7)
		{
		    scr_DestroyObject(xx,yy,obj_ScrewBlock);
		}
	}
}
breakList = ds_list_create();
function scr_DestroyObject(xx,yy,objIndex)
{
	var _num = instance_place_list(xx,yy,objIndex,breakList,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			instance_destroy(breakList[| i]);
		}
	}
	ds_list_clear(breakList);
}
#endregion
#region scr_OpenDoor
function scr_OpenDoor(_x,_y,_type)
{
	if(place_meeting(_x,_y,obj_DoorHatch) && _type > -1)
	{
		var door = instance_place(_x,_y,obj_DoorHatch);
		if(instance_exists(door) && (door.object_index == obj_DoorHatch || (door.object_index == obj_DoorHatch_Locked && door.unlocked)))
		{
			//door.hitPoints -= 1;
			scr_DamageDoor(_x,_y,obj_DoorHatch,1);
		}
		if(_type == 1 || _type == 2 || _type == 4)
		{
			if(_type == 2 || _type == 4)
			{
				scr_DamageDoor(_x,_y,obj_DoorHatch_Missile,5);
			}
			else
			{
				scr_DamageDoor(_x,_y,obj_DoorHatch_Missile,1);
			}
		}
		if(_type == 2 || _type == 4)
		{
			scr_DamageDoor(_x,_y,obj_DoorHatch_Super,1);
		}
		if(_type == 3 || _type == 4)
		{
			scr_DamageDoor(_x,_y,obj_DoorHatch_Power,1);
		}
	}
}
doorList = ds_list_create();
function scr_DamageDoor(_x,_y,_objIndex,_dmg)
{
	var _num = instance_place_list(_x,_y,_objIndex,doorList,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			doorList[| i].DamageHatch(_dmg);
		}
	}
	ds_list_clear(doorList);
}
#endregion