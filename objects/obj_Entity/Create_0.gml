/// @description Initialize

position = new Vector2(x,y);

velX = 0; // velocity x
velY = 0; // velocity y
fVelX = 0; // final velocity x
fVelY = 0; // final velocity y

shiftedVelX = 0;
shiftedVelY = 0;

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

solids[0] = "ISolid";
solids[1] = "IMovingSolid";
function CanPlatformCollide()
{
	return false;
}

blockList = ds_list_create();
edgeSlope = ds_list_create();

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
		xx = position.X,
		yy = position.Y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	if(lhc_place_meeting(xx+offsetX,yy+offsetY,"IPlatform") && CanPlatformCollide())
	{
		if(entityPlatformCheck(offsetX,offsetY,xx,yy))
		{
			return true;
		}
	}
	
	return entity_collision(instance_place_list(xx+offsetX,yy+offsetY,all,blockList,true));
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
		xx = position.X,
		yy = position.Y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	//return lhc_position_meeting(xx+offsetX,yy+offsetY,solids);
	return entity_collision(instance_position_list(xx+offsetX,yy+offsetY,all,blockList,true));
}

function entity_collision_line(x1,y1,x2,y2, prec = true, notme = true)
{
	//return lhc_collision_line(x1,y1,x2,y2,solids,prec,notme);
	return entity_collision(collision_line_list(x1,y1,x2,y2,all,prec,notme,blockList,true));
}

function entity_collision(listNum)
{
	for(var i = 0; i < listNum; i++)
	{
		if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,solids,asset_object))
		{
			var block = blockList[| i];
			var isSolid = true;
			if(block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
			{
				isSolid = block.isSolid;
			}
			if(isSolid)
			{
				ds_list_clear(blockList);
				return true;
			}
		}
	}
	ds_list_clear(blockList);
	return false;
}

function entityPlatformCheck()
{
	/// @description entityPlatformCheck
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = scr_round(position.X),
		yy = scr_round(position.Y);
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	
	if(lhc_place_meeting(xx+offsetX,yy+offsetY,"IPlatform"))
	{
		var pl = instance_place_list(xx+offsetX,yy+offsetY,all,blockList,true);
		for(var i = 0; i < pl; i++)
		{
			if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,"IPlatform",asset_object))
			{
				var platform = blockList[| i];
				if(platform.isSolid && place_meeting(xx+offsetX,yy+offsetY,platform) && !place_meeting(xx,yy,platform) && bbox_bottom < platform.bbox_top)
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
		
	var col = instance_place_list(scr_round(position.X)+xcheck,scr_round(position.Y)+ycheck,all,edgeSlope,true);
	if(col > 0)
	{
		for(var i = 0; i < col; i++)
		{
			if(!instance_exists(edgeSlope[| i]) || !asset_has_any_tag(edgeSlope[| i].object_index,solids,asset_object) || !asset_has_any_tag(edgeSlope[| i].object_index,"ISlope",asset_object))
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
#region GetSlopeAngle
/*function GetSlopeAngle(slope)
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
}*/
#endregion
#region GetEdgeAngle
function GetEdgeAngle(edge, margin = 1)
{
	var pos1 = new Vector2(0,0),
		pos2 = new Vector2(0,0);
	
	var checkDir = 1;
	
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
		ang = 270;
	}
	
	if(edge == Edge.Bottom || edge == Edge.Top)
	{
		pos1.Y = margin;
		if(edge == Edge.Top)
		{
			pos1.Y = -margin;
		}
		if(entity_place_collide(pos1.X,pos1.Y))
		{
			while(entity_place_collide(pos1.X,pos1.Y))
			{
				if(checkDir == 1)
				{
					pos1.X++;
					if(pos1.X > 8)
					{
						pos1.X = 0;
						checkDir = -1;
					}
				}
				if(checkDir == -1)
				{
					pos1.X--;
					if(pos1.X < -8)
					{
						pos1.X = 0;
						checkDir = 0;
						break;
					}
				}
			}
			
			if(checkDir != 0 && entity_place_collide(pos1.X,pos1.Y*2))
			{
				while(!entity_place_collide(pos2.X,pos2.Y) && abs(pos2.X) < 8)
				{
					pos2.X -= checkDir;
				}
				if(abs(pos2.X) < 8)
				{
					pos2.X += checkDir;
					
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
	}
	
	if(edge == Edge.Right || edge == Edge.Left)
	{
		pos1.X = margin;
		if(edge == Edge.Left)
		{
			pos1.X = -margin;
		}
		if(entity_place_collide(pos1.X,pos1.Y))
		{
			while(entity_place_collide(pos1.X,pos1.Y))
			{
				if(checkDir == 1)
				{
					pos1.Y++;
					if(pos1.Y > 8)
					{
						pos1.Y = 0;
						checkDir = -1;
					}
				}
				if(checkDir == -1)
				{
					pos1.Y--;
					if(pos1.Y < -8)
					{
						pos1.Y = 0;
						checkDir = 0;
						break;
					}
				}
			}
			if(checkDir != 0 && entity_place_collide(pos1.X*2,pos1.Y))
			{
				while(!entity_place_collide(pos2.X,pos2.Y) && abs(pos2.Y) < 8)
				{
					pos2.Y -= checkDir;
				}
				if(abs(pos2.Y) < 8)
				{
					pos2.Y += checkDir;
					
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
	}
	
	return scr_wrap(ang,0,360);
}
#endregion

#region Collision Hooks

function ModifyFinalVelX(fVX) { return fVX; }
function ModifyFinalVelY(fVY) { return fVY; }

function ModifySlopeXSteepness_Up() { return 3; }
function ModifySlopeXSteepness_Down() { return 4; }
function ModifySlopeYSteepness_Up() { return 3; }
function ModifySlopeYSteepness_Down() { return 4; }

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
function Collision_Normal(vX, vY, vStepX, vStepY, slopeSpeedAdjust)//platformCol, slopeSpeedAdjust)
{
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while((maxSpeedX > 0 && vStepX > 0) || (maxSpeedY > 0 && vStepY > 0))
	{
		var vX2 = min(maxSpeedX,vStepX)*sign(vX);
		
		/*var sAngle = 0;
		var slope = GetEdgeSlope(Edge.Bottom);
		if(instance_exists(slope) && slopeSpeedAdjust)
		{
			if(SlopeCheck(slope))
			{
				sAngle = GetSlopeAngle(slope);
			}
		}*/
		var sAngle = 0;
		if(slopeSpeedAdjust)
		{
			sAngle = GetEdgeAngle(Edge.Bottom);
		}
		
		var fVX = lengthdir_x(vX2,sAngle);
		fVX = ModifyFinalVelX(fVX);
		
		#region X Collision
		
		DestroyBlock(scr_round(position.X)+fVX,scr_round(position.Y));
		
		var yplusMax = vStepX+1;
		
		var colR = entity_collision_line(bbox_right+fVX,bbox_top,bbox_right+fVX,bbox_bottom),
			colL = entity_collision_line(bbox_left+fVX,bbox_top,bbox_left+fVX,bbox_bottom);
		var xspeed = abs(fVX);
		if(entity_place_collide(max(abs(fVX),1)*sign(fVX),0) && (!entity_place_collide(0,0) || (fVX > 0 && colR) || (fVX < 0 && colL)))
		{
			var steepness = ModifySlopeXSteepness_Up();
			
			var yplus = 0;
			while(entity_place_collide(fVX,yplus) && yplus >= -yplusMax)
			{
				yplus--;
				DestroyBlock(scr_round(position.X)+sign(fVX),scr_round(position.Y)+min(yplus,-steepness));
				DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+min(yplus,-steepness));
			}
			while(entity_place_collide(fVX,yplus) && yplus <= yplusMax)
			{
				yplus++;
				DestroyBlock(scr_round(position.X)+sign(fVX),scr_round(position.Y)+max(yplus,steepness));
				DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+max(yplus,steepness));
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
					position.X = scr_floor(position.X);
				}
				if(fVX < 0)
				{
					OnLeftCollision(fVX);
					position.X = scr_ceil(position.X);
				}
				var xnum2 = xspeed+2;
				while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
				{
					position.X += sign(fVX);
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
					OnSlopeXCollision_Top(fVX,yplus);
					position.Y = floor(position.Y + yplus);
					if(entity_place_collide(fVX,0))
					{
						position.Y += 1;
					}
				}
				else
				{
					OnSlopeXCollision_Bottom(fVX,yplus);
					position.Y = ceil(position.Y + yplus);
					if(entity_place_collide(fVX,0))
					{
						position.Y -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0))
		{
			var steepness = ModifySlopeXSteepness_Down();
			
			DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+min(abs(fVX),steepness+2));
			DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)-min(abs(fVX),steepness+2));
			
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
			
			var moveDownSlope_Bottom = (entity_place_collide(0,1) && entity_place_collide(xnum3*sign(fVX)+sign(fVX),steepness) && CanMoveDownSlope_Bottom());
			var moveDownSlope_Top = (entity_place_collide(0,-1) && entity_place_collide(xnum4*sign(fVX)+sign(fVX),-steepness) && CanMoveDownSlope_Top());
			
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
					
				DestroyBlock(scr_round(position.X)+fVX,scr_round(position.Y)+yplus2+sign(yplus2));
			
				if(!entity_place_collide(fVX,yplus2))
				{
					if(entity_place_collide(fVX,yplus2+sign(yplus2)))
					{
						if(yplus2 > 0)
						{
							position.Y = ceil(position.Y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								position.Y -= 1;
							}
						}
						else
						{
							position.Y = floor(position.Y + yplus2);
							if(entity_place_collide(fVX,0))
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
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
	
	
		var vY2 = min(maxSpeedY,vStepY)*sign(vY);
		
		var left_rot = 270,
			right_rot = 90;
		
		/*var sAngle2 = 0;
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
		}*/
		var sAngle2 = 0;
		if(slopeSpeedAdjust)
		{
			sAngle2 = angle_difference(GetEdgeAngle(Edge.Top),180);
		}
		
		var fVY = lengthdir_x(vY2,sAngle2);
		fVY = ModifyFinalVelY(fVY);
		
		#region Y Collision
		
		DestroyBlock(scr_round(position.X),scr_round(position.Y)+fVY);
		
		var xplusMax = vStepY+1;
		
		var colB = entity_collision_line(bbox_left,bbox_bottom+fVY,bbox_right,bbox_bottom+fVY),
			colT = entity_collision_line(bbox_left,bbox_top+fVY,bbox_right,bbox_top+fVY);
		var yspeed = abs(fVY);
		if(entity_place_collide(0,max(abs(fVY),1)*sign(fVY)) && (!entity_place_collide(0,0) || (fVY > 0 && colB) || (fVY < 0 && colT)))
		{
			var steepness = ModifySlopeYSteepness_Up();
			
			var xplus = 0;
			while(entity_place_collide(xplus,fVY) && xplus >= -xplusMax)
			{
				xplus--;
				DestroyBlock(scr_round(position.X)+min(xplus,-steepness),scr_round(position.Y)+sign(fVY));
				DestroyBlock(scr_round(position.X)+min(xplus,-steepness),scr_round(position.Y)+fVY+sign(fVY));
			}
			while(entity_place_collide(xplus,fVY) && xplus <= xplusMax)
			{
				xplus++;
				DestroyBlock(scr_round(position.X)+max(xplus,steepness),scr_round(position.Y)+sign(fVY));
				DestroyBlock(scr_round(position.X)+max(xplus,steepness),scr_round(position.Y)+fVY+sign(fVY));
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
					position.Y = scr_floor(position.Y);
				}
				if(fVY < 0)
				{
					OnTopCollision(fVY);
					position.Y = scr_ceil(position.Y);
				}
				var ynum2 = yspeed+2;
				while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
				{
					position.Y += sign(fVY);
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
					OnSlopeYCollision_Left(fVY,xplus);
					position.X = floor(position.X + xplus);
					if(entity_place_collide(0,fVY))
					{
						position.X += 1;
					}
				}
				else
				{
					OnSlopeYCollision_Right(fVY,xplus);
					position.X = ceil(position.X + xplus);
					if(entity_place_collide(0,fVY))
					{
						position.X -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0))
		{
			var steepness = ModifySlopeYSteepness_Down();
			
			DestroyBlock(scr_round(position.X)+min(abs(fVY),steepness+2),scr_round(position.Y)+fVY+sign(fVY));
			DestroyBlock(scr_round(position.X)-min(abs(fVY),steepness+2),scr_round(position.Y)+fVY+sign(fVY));
			
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
			
			var moveDownSlope_Right = (entity_place_collide(1,0) && entity_place_collide(steepness,ynum3*sign(fVY)+sign(fVY)) && CanMoveDownSlope_Right());
			var moveDownSlope_Left = (entity_place_collide(-1,0) && entity_place_collide(-steepness,ynum4*sign(fVY)+sign(fVY)) && CanMoveDownSlope_Left());
			
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
					
				DestroyBlock(scr_round(position.X)+xplus2+sign(xplus2),scr_round(position.Y)+fVY);
			
				if(!entity_place_collide(xplus2,fVY))
				{
					if(entity_place_collide(xplus2+sign(xplus2),fVY))
					{
						if(xplus2 > 0)
						{
							position.X = ceil(position.X + xplus2);
							if(entity_place_collide(0,fVY))
							{
								position.X -= 1;
							}
						}
						else
						{
							position.X = floor(position.X + xplus2);
							if(entity_place_collide(0,fVY))
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
		
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
	
	x = scr_round(position.X);
	y = scr_round(position.Y);
	
	shiftedVelX = 0;
	shiftedVelY = 0;
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
	return (colEdge == Edge.Right);
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
	return (colEdge == Edge.Left);
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
		/*var slope = GetEdgeSlope(colEdge);
		if(instance_exists(slope) && slopeSpeedAdjust)
		{
			if(Crawler_SlopeCheck(slope))
			{
				sAngle2 = angle_difference(GetSlopeAngle(slope),sAngle);
			}
		}*/
		if(slopeSpeedAdjust)
		{
			sAngle2 = angle_difference(GetEdgeAngle(colEdge),sAngle);
		}
		
		var fVX = lengthdir_x(vX2,sAngle2);
		fVX = Crawler_ModifyFinalVelX(fVX);
		
		#region X Collision
		
		Crawler_DestroyBlock(scr_round(position.X)+fVX,scr_round(position.Y));
		
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
				Crawler_DestroyBlock(scr_round(position.X)+sign(fVX),scr_round(position.Y)+min(yplus,-steepness));
				Crawler_DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+min(yplus,-steepness));
			}
			while(entity_place_collide(fVX,yplus) && yplus <= yplusMax)
			{
				yplus++;
				Crawler_DestroyBlock(scr_round(position.X)+sign(fVX),scr_round(position.Y)+max(yplus,steepness));
				Crawler_DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+max(yplus,steepness));
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
					position.X = scr_floor(position.X);
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
					position.X = scr_ceil(position.X);
				}
				var xnum2 = xspeed+2;
				while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
				{
					position.X += sign(fVX);
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
					Crawler_OnSlopeXCollision_Top(fVX,yplus);
					position.Y = floor(position.Y + yplus);
					if(entity_place_collide(fVX,0))
					{
						position.Y += 1;
					}
				}
				else
				{
					Crawler_OnSlopeXCollision_Bottom(fVX,yplus);
					position.Y = ceil(position.Y + yplus);
					if(entity_place_collide(fVX,0))
					{
						position.Y -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && (colEdge == Edge.Bottom || colEdge == Edge.Top))
		{
			var steepness = 3;
			
			Crawler_DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+min(abs(fVX),steepness+2));
			Crawler_DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)-min(abs(fVX),steepness+2));
			
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
					
				Crawler_DestroyBlock(scr_round(position.X)+fVX,scr_round(position.Y)+yplus2+sign(yplus2));
			
				if(!entity_place_collide(fVX,yplus2))
				{
					if(entity_place_collide(fVX,yplus2+sign(yplus2)))
					{
						if(yplus2 > 0)
						{
							position.Y = ceil(position.Y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								position.Y -= 1;
							}
						}
						else
						{
							position.Y = floor(position.Y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								position.Y += 1;
							}
						}
					}
				}
			}
			else
			{
				if(fVX > 0)
				{
					position.X = scr_floor(position.X);
					colEdge = Edge.Left;
				}
				if(fVX < 0)
				{
					position.X = scr_ceil(position.X);
					colEdge = Edge.Right;
				}
				var xnum2 = xspeed+2;
				while(entity_place_collide(0,ydir) && xnum2 > 0)
				{
					position.X += sign(fVX);
					xnum2--;
				}
				if(!entity_place_collide(0,ydir))
				{
					position.Y += ydir;
				}
				
				vX *= -1;
				fVX = 0;
				maxSpeedX = 0;
			}
		}
		
		#endregion
		
		position.X += fVX;
		
		
		var vY2 = min(maxSpeedY,vStepY)*sign(vY);
		var fVY = lengthdir_x(vY2,sAngle2);
		fVY = Crawler_ModifyFinalVelY(fVY);
		
		#region Y Collision
		
		Crawler_DestroyBlock(scr_round(position.X),scr_round(position.Y)+fVY);
		
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
				Crawler_DestroyBlock(scr_round(position.X)+min(xplus,-steepness),scr_round(position.Y)+sign(fVY));
				Crawler_DestroyBlock(scr_round(position.X)+min(xplus,-steepness),scr_round(position.Y)+fVY+sign(fVY));
			}
			while(entity_place_collide(xplus,fVY) && xplus <= xplusMax)
			{
				xplus++;
				Crawler_DestroyBlock(scr_round(position.X)+max(xplus,steepness),scr_round(position.Y)+sign(fVY));
				Crawler_DestroyBlock(scr_round(position.X)+max(xplus,steepness),scr_round(position.Y)+fVY+sign(fVY));
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
					position.Y = scr_floor(position.Y);
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
					position.Y = scr_ceil(position.Y);
				}
				var ynum2 = yspeed+2;
				while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
				{
					position.Y += sign(fVY);
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
					Crawler_OnSlopeYCollision_Left(fVY,xplus);
					position.X = floor(position.X + xplus);
					if(entity_place_collide(0,fVY))
					{
						position.X += 1;
					}
				}
				else
				{
					Crawler_OnSlopeYCollision_Right(fVY,xplus);
					position.X = ceil(position.X + xplus);
					if(entity_place_collide(0,fVY))
					{
						position.X -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && (colEdge == Edge.Left || colEdge == Edge.Right))
		{
			var steepness = 3;
			
			Crawler_DestroyBlock(scr_round(position.X)+min(abs(fVY),steepness+2),scr_round(position.Y)+fVY+sign(fVY));
			Crawler_DestroyBlock(scr_round(position.X)-min(abs(fVY),steepness+2),scr_round(position.Y)+fVY+sign(fVY));
			
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
					
				Crawler_DestroyBlock(scr_round(position.X)+xplus2+sign(xplus2),scr_round(position.Y)+fVY);
			
				if(!entity_place_collide(xplus2,fVY))
				{
					if(entity_place_collide(xplus2+sign(xplus2),fVY))
					{
						if(xplus2 > 0)
						{
							position.X = ceil(position.X + xplus2);
							if(entity_place_collide(0,fVY))
							{
								position.X -= 1;
							}
						}
						else
						{
							position.X = floor(position.X + xplus2);
							if(entity_place_collide(0,fVY))
							{
								position.X += 1;
							}
						}
					}
				}
			}
			else
			{
				if(fVY > 0)
				{
					position.Y = scr_floor(position.Y);
					colEdge = Edge.Top;
				}
				if(fVY < 0)
				{
					position.Y = scr_ceil(position.Y);
					colEdge = Edge.Bottom;
				}
				var ynum2 = yspeed+2;
				while(entity_place_collide(xdir,0) && ynum2 > 0)
				{
					position.Y += sign(fVY);
					ynum2--;
				}
				if(!entity_place_collide(xdir,0))
				{
					position.X += xdir;
				}
				
				vY *= -1;
				fVY = 0;
				maxSpeedY = 0;
			}
		}
		
		#endregion
		
		position.Y += fVY;
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
	
	x = scr_round(position.X);
	y = scr_round(position.Y);
	
	shiftedVelX = 0;
	shiftedVelY = 0;
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

function Collision_MovingSolid(vX, vY, vStepX, vStepY, upSlopeSteepness_X = 5, downSlopeSteepness_X = 5, upSlopeSteepness_Y = 5, downSlopeSteepness_Y = 5)
{
	var maxSpeedX = abs(vX),
		maxSpeedY = abs(vY);
	while((maxSpeedX > 0 && vStepX > 0) || (maxSpeedY > 0 && vStepY > 0))
	{
		var fVX = min(maxSpeedX,vStepX)*sign(vX);
		
		#region X Collision
		
		DestroyBlock(scr_round(position.X)+fVX,scr_round(position.Y));
		
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
				DestroyBlock(scr_round(position.X)+sign(fVX),scr_round(position.Y)+min(yplus,-steepness));
				DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+min(yplus,-steepness));
			}
			while(entity_place_collide(fVX,yplus) && yplus <= yplusMax)
			{
				yplus++;
				DestroyBlock(scr_round(position.X)+sign(fVX),scr_round(position.Y)+max(yplus,steepness));
				DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+max(yplus,steepness));
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
					MovingSolid_OnRightCollision(fVX);
					position.X = scr_floor(position.X);
				}
				if(fVX < 0)
				{
					MovingSolid_OnLeftCollision(fVX);
					position.X = scr_ceil(position.X);
				}
				var xnum2 = xspeed+2;
				while(!entity_place_collide(sign(fVX),0) && xnum2 > 0)
				{
					position.X += sign(fVX);
					xnum2--;
				}
				MovingSolid_OnXCollision(fVX);
				fVX = 0;
				maxSpeedX = 0;
			}
			else
			{
				if(yplus > 0)
				{
					position.Y = floor(position.Y + yplus);
					if(entity_place_collide(fVX,0))
					{
						position.Y += 1;
					}
				}
				else
				{
					position.Y = ceil(position.Y + yplus);
					if(entity_place_collide(fVX,0))
					{
						position.Y -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && downSlopeSteepness_X > 0)
		{
			var steepness = downSlopeSteepness_X;
			
			DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)+min(abs(fVX),steepness+2));
			DestroyBlock(scr_round(position.X)+fVX+sign(fVX),scr_round(position.Y)-min(abs(fVX),steepness+2));
			
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
			
			var moveDownSlope_Bottom = (entity_place_collide(0,1) && entity_place_collide(xnum3*sign(fVX)+sign(fVX),steepness));
			var moveDownSlope_Top = (entity_place_collide(0,-1) && entity_place_collide(xnum4*sign(fVX)+sign(fVX),-steepness));
			
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
					
				DestroyBlock(scr_round(position.X)+fVX,scr_round(position.Y)+yplus2+sign(yplus2));
			
				if(!entity_place_collide(fVX,yplus2))
				{
					if(entity_place_collide(fVX,yplus2+sign(yplus2)))
					{
						if(yplus2 > 0)
						{
							position.Y = ceil(position.Y + yplus2);
							if(entity_place_collide(fVX,0))
							{
								position.Y -= 1;
							}
						}
						else
						{
							position.Y = floor(position.Y + yplus2);
							if(entity_place_collide(fVX,0))
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
		
		maxSpeedX = max(maxSpeedX-vStepX,0);
	
	
		var fVY = min(maxSpeedY,vStepY)*sign(vY);
		
		#region Y Collision
		
		DestroyBlock(scr_round(position.X),scr_round(position.Y)+fVY);
		
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
				DestroyBlock(scr_round(position.X)+min(xplus,-steepness),scr_round(position.Y)+sign(fVY));
				DestroyBlock(scr_round(position.X)+min(xplus,-steepness),scr_round(position.Y)+fVY+sign(fVY));
			}
			while(entity_place_collide(xplus,fVY) && xplus <= xplusMax)
			{
				xplus++;
				DestroyBlock(scr_round(position.X)+max(xplus,steepness),scr_round(position.Y)+sign(fVY));
				DestroyBlock(scr_round(position.X)+max(xplus,steepness),scr_round(position.Y)+fVY+sign(fVY));
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
					MovingSolid_OnBottomCollision(fVY);
					position.Y = scr_floor(position.Y);
				}
				if(fVY < 0)
				{
					MovingSolid_OnTopCollision(fVY);
					position.Y = scr_ceil(position.Y);
				}
				var ynum2 = yspeed+2;
				while(!entity_place_collide(0,sign(fVY)) && ynum2 > 0)
				{
					position.Y += sign(fVY);
					ynum2--;
				}
				MovingSolid_OnYCollision(fVY);
				fVY = 0;
				maxSpeedY = 0;
			}
			else
			{
				if(xplus > 0)
				{
					position.X = floor(position.X + xplus);
					if(entity_place_collide(0,fVY))
					{
						position.X += 1;
					}
				}
				else
				{
					position.X = ceil(position.X + xplus);
					if(entity_place_collide(0,fVY))
					{
						position.X -= 1;
					}
				}
			}
		}
		else if(!entity_place_collide(0,0) && downSlopeSteepness_Y > 0)
		{
			var steepness = downSlopeSteepness_Y;
			
			DestroyBlock(scr_round(position.X)+min(abs(fVY),steepness+2),scr_round(position.Y)+fVY+sign(fVY));
			DestroyBlock(scr_round(position.X)-min(abs(fVY),steepness+2),scr_round(position.Y)+fVY+sign(fVY));
			
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
			
			var moveDownSlope_Right = (entity_place_collide(1,0) && entity_place_collide(steepness,ynum3*sign(fVY)+sign(fVY)));
			var moveDownSlope_Left = (entity_place_collide(-1,0) && entity_place_collide(-steepness,ynum4*sign(fVY)+sign(fVY)));
			
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
					
				DestroyBlock(scr_round(position.X)+xplus2+sign(xplus2),scr_round(position.Y)+fVY);
			
				if(!entity_place_collide(xplus2,fVY))
				{
					if(entity_place_collide(xplus2+sign(xplus2),fVY))
					{
						if(xplus2 > 0)
						{
							position.X = ceil(position.X + xplus2);
							if(entity_place_collide(0,fVY))
							{
								position.X -= 1;
							}
						}
						else
						{
							position.X = floor(position.X + xplus2);
							if(entity_place_collide(0,fVY))
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
		
		maxSpeedY = max(maxSpeedY-vStepY,0);
	}
	
	x = scr_round(position.X);
	y = scr_round(position.Y);
	
	shiftedVelX = 0;
	shiftedVelY = 0;
}
#endregion

#region BreakBlock
function BreakBlock(xx,yy,type)
{
	if(place_meeting(xx,yy,obj_Breakable) && type > -1)
	{
		DestroyObject(xx,yy,obj_ShotBlock);
	
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
		    DestroyObject(xx,yy,obj_BombBlock);

		    if(type == 1 || type == 7)
		    {
		        DestroyObject(xx,yy,obj_ChainBlock);
		    }
		}

		if(type == 2 || type == 3 || type == 7)
		{
		    DestroyObject(xx,yy,obj_MissileBlock);
		}

		if(type == 3 || type == 7)
		{
		    DestroyObject(xx,yy,obj_SuperMissileBlock);
		}

		if(type == 4 || type == 7)
		{
		    DestroyObject(xx,yy,obj_PowerBombBlock);
		}

		if(type == 5 || type == 7)
		{
		    DestroyObject(xx,yy,obj_SpeedBlock);
		}

		if(type == 6 || type == 7)
		{
		    DestroyObject(xx,yy,obj_ScrewBlock);
		}
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
			instance_destroy(breakList[| i]);
		}
	}
	ds_list_clear(breakList);
}
#endregion
#region OpenDoor
function OpenDoor(_x,_y,_type)
{
	if(place_meeting(_x,_y,obj_DoorHatch) && _type > -1)
	{
		DamageDoor(_x,_y,obj_DoorHatch,1);
		DamageDoor(_x,_y,obj_DoorHatch_Locked,1);
		
		if(_type == 1 || _type == 2 || _type == 4)
		{
			if(_type == 2 || _type == 4)
			{
				DamageDoor(_x,_y,obj_DoorHatch_Missile,5);
			}
			else
			{
				DamageDoor(_x,_y,obj_DoorHatch_Missile,1);
			}
		}
		if(_type == 2 || _type == 4)
		{
			DamageDoor(_x,_y,obj_DoorHatch_Super,1);
		}
		if(_type == 3 || _type == 4)
		{
			DamageDoor(_x,_y,obj_DoorHatch_Power,1);
		}
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
			if(instance_exists(doorList[| i]) && doorList[| i].object_index == _objIndex && doorList[| i].unlocked)
			{
				doorList[| i].DamageHatch(_dmg);
			}
		}
	}
	ds_list_clear(doorList);
}
#endregion
#region ShutterSwitch
switchCollide = true;
function ShutterSwitch(_x,_y,_type)
{
	var sSwitch = instance_place(_x,_y,obj_ShutterSwitch);
	if(instance_exists(sSwitch) && _type > -1)
	{
		ToggleSwitch(_x,_y,obj_ShutterSwitch);
		
		if(_type == 1 || _type == 2 || _type == 4)
		{
			ToggleSwitch(_x,_y,obj_ShutterSwitch_Missile);
		}
		if(_type == 2 || _type == 4)
		{
			ToggleSwitch(_x,_y,obj_ShutterSwitch_Super);
		}
		if(_type == 3 || _type == 4)
		{
			ToggleSwitch(_x,_y,obj_ShutterSwitch_Power);
		}
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
			if(instance_exists(switchList[| i]) && switchList[| i].object_index == _objIndex)
			{
				var sSwitch = switchList[| i];
				var flag = true;
				if(switchCollide)
				{
					var entity = id;
					with(sSwitch)
					{
						if(lhc_collision_line(entity.x,entity.y,x+8*image_xscale,y+8*image_yscale,entity.solids,true,true))
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
	return instance_place(x,y,obj_Liquid);
}
#endregion
#region liquid_top
function liquid_top()
{
	return collision_line(bbox_left, bbox_top, bbox_right, bbox_top, obj_Liquid, true, true);
}
#endregion

liquid = liquid_place();
liquidPrev = liquid;
liquidTop = liquid_top();
liquidTopPrev = liquidTop;

enteredLiquid = -1;
leftLiquid = -1;
leftLiquidTop = -1;
leftLiquidType = LiquidType.Water;
leftLiquidTopType = LiquidType.Water;

canSplash = 1;
breathTimer = 180;
stepSplash = 0;

prevTop = bbox_top;
prevBottom = bbox_bottom;

#region EntityLiquid

function EntityLiquid(_mass, _velX, _velY, _sound = true, _isBeam = false, _isMissile = false)
{
	liquid = liquid_place();
	liquidTop = liquid_top();
	enteredLiquid = max(enteredLiquid-1,0);
	leftLiquid = max(leftLiquid-1,0);
	leftLiquidTop = max(leftLiquidTop-1,0);
	
	var returnLiq = liquid;
	
	if(liquid != liquidPrev)
	{
		if(liquid && prevBottom < liquid.bbox_top)
		{
			liquid.CreateSplash(id,_mass,_velX,_velY,true,_sound,_isBeam)
			enteredLiquid = (_mass+1) * 15;
		}
		else if(liquidPrev && bbox_bottom < liquidPrev.bbox_top && !_isBeam)
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
		if(!liquidTop && liquidTopPrev && bbox_top < liquidTopPrev.bbox_top && !_isMissile)
		{
			liquidTopPrev.CreateSplash(id,_mass,_velX,_velY,false,_sound,_isBeam);
			returnLiq = liquidTopPrev;
			leftLiquidTop = (_mass+1) * 12.5;
			leftLiquidTopType = liquidTopPrev.liquidType;
		}
		liquidTopPrev = liquidTop;
	}
	
	prevTop = bbox_top;
	prevBottom = bbox_bottom;
	
	return returnLiq;
}

#endregion
#region EntityLiquid_Large

function EntityLiquid_Large(_velX, _velY)
{
	EntityLiquid(2,_velX,_velY, true, false, false);
	
	canSplash++;
	if(canSplash > 10)
	{
		canSplash = 0;
	}
	
	if(liquid && !liquidTop && (canSplash%2) == 0)
	{
		liquid.CreateSplash_Extra(id,0,_velX,_velY,true,false);
	}
	
	if(liquid && enteredLiquid > 0 && choose(1,1,1,0) == 1)
	{
		var bub = liquid.CreateBubble(x-8+random(16),bbox_top+random(bbox_bottom-bbox_top),0,0);
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
		var drop = instance_create_depth(x-8+random(16),bbox_bottom+random(bbox_top-y+4),depth-1,obj_WaterDrop);
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