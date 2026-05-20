/// @description 

isSolid = true;

entityList = ds_list_create();

ignoredEntity = noone;
tempIgnoredEnt = noone;

function IsValidEntity(entity)
{
	return (entity != tempIgnoredEnt && entity != ignoredEntity && array_contains_ext(entity.solids, ColType_MovingSolid, false));
}

function IsEntity_Top(entity)
{
	var this = id;
	with(entity)
	{
		return place_meeting(x,y+1,this) || place_meeting(position.X,position.Y+1,this);
	}
	return place_meeting(x,y-1,entity);
}
function IsEntity_Bottom(entity)
{
	var this = id;
	with(entity)
	{
		return place_meeting(x,y-1,this) || place_meeting(position.X,position.Y-1,this);
	}
	return place_meeting(x,y+1,entity);
}
function IsEntity_Left(entity)
{
	var this = id;
	with(entity)
	{
		return place_meeting(x+1,y,this) || place_meeting(position.X+1,position.Y,this);
	}
	return place_meeting(x-1,y,entity);
}
function IsEntity_Right(entity)
{
	var this = id;
	with(entity)
	{
		return place_meeting(x-1,y,this) || place_meeting(position.X-1,position.Y,this);
	}
	return place_meeting(x+1,y,entity);
}

function EntityPush_X(entity) { return true; }
function EntityPush_Y(entity) { return true; }
avoidClipX = true;
avoidClipY = true;

function UpdatePosition(_x,_y, avoidClipping = false, _self = noone)
{
	// round x and y just in case
	x = scr_round(x);
	y = scr_round(y);
	
	var newPosX = scr_round(_x),
		newPosY = scr_round(_y);
	
	var bVelX = newPosX-x,
		bVelY = newPosY-y;
	
	var maxSpeedX = abs(bVelX),
		maxSpeedY = abs(bVelY);
	while(maxSpeedX > 0 || maxSpeedY > 0)
	{
		var bVX = min(maxSpeedX,1)*sign(bVelX);
		var bVY = min(maxSpeedY,1)*sign(bVelY);
		
		var elNum = collision_rectangle_list(bbox_left-2,bbox_top-2,bbox_right+1,bbox_bottom+1,obj_Entity,true,true,entityList,true);
		
		if(elNum > 0)
		{
			for(var i = 0; i < elNum; i++)
			{
				var entity = entityList[| i];
				if(instance_exists(entity) && self.IsValidEntity(entity))
				{
					var tileCollide = true;
					if(object_is_ancestor(entity.object_index,obj_NPC))
					{
						tileCollide = entity.tileCollide;
					}
					if(object_is_ancestor(entity.object_index,obj_Projectile))
					{
						tileCollide = false;
					}
					if(entity.passthroughMovingSolids)
					{
						tileCollide = false;
					}
					if(!tileCollide) { continue; }
					
					
					var moveX = 0,
						moveY = 0;
					var moveXFlag = false,
						moveYFlag = false,
						moveXFlag2 = false,
						moveYFlag2 = false;
				
					var edgeTop = self.IsEntity_Top(entity),
						edgeBottom = self.IsEntity_Bottom(entity),
						edgeLeft = self.IsEntity_Left(entity),
						edgeRight = self.IsEntity_Right(entity);
				
					var entityEdgeBottomX = entity.MoveStickBottom_X(id),
						entityEdgeBottomY = entity.MoveStickBottom_Y(id),
						entityEdgeTopX = entity.MoveStickTop_X(id),
						entityEdgeTopY = entity.MoveStickTop_Y(id),
						entityEdgeRightX = entity.MoveStickRight_X(id),
						entityEdgeRightY = entity.MoveStickRight_Y(id),
						entityEdgeLeftX = entity.MoveStickLeft_X(id),
						entityEdgeLeftY = entity.MoveStickLeft_Y(id);
					
					var entPushX = self.EntityPush_X(entity),
						entPushY = self.EntityPush_Y(entity);
				
					if ((edgeTop && entityEdgeBottomX) ||
						(edgeBottom && entityEdgeTopX) ||
						(edgeLeft && (entityEdgeRightX || (bVX < 0 && entPushX))) || 
						(edgeRight && (entityEdgeLeftX || (bVX > 0 && entPushX))))
					{
						moveXFlag = true;
						if(entPushX && ((edgeLeft && bVX < 0) || (edgeRight && bVX > 0)))
						{
							moveXFlag2 = avoidClipX;
						}
					}
					if ((edgeTop && (entityEdgeBottomY || (bVY < 0 && entPushY))) || 
						(edgeBottom && (entityEdgeTopY || (bVY > 0 && entPushY))) ||
						(edgeLeft && entityEdgeRightY) || 
						(edgeRight && entityEdgeLeftY))
					{
						moveYFlag = true;
						if(entPushY && ((edgeTop && bVY < 0) || (edgeBottom && bVY > 0)))
						{
							moveYFlag2 = avoidClipY;
						}
					}
					
					if(entPushX)
					{
						if(place_meeting(x+bVX,y,entity) || (place_meeting(x+bVX,y+bVY,entity) && !place_meeting(x,y+bVY,entity)))
						{
							moveXFlag = true;
							moveXFlag2 = avoidClipX;
						}
					}
					if(entPushY)
					{
						if(place_meeting(x,y+bVY,entity) || (place_meeting(x+bVX,y+bVY,entity) && !place_meeting(x+bVX,y,entity)))
						{
							moveYFlag = true;
							moveYFlag2 = avoidClipY;
						}
					}
				
					with(entity)
					{
						var bVelX2 = bVelX,
							bVelY2 = bVelY;
						bVelX2 -= movedVelX;
						bVelY2 -= movedVelY;
						if(_self != noone)
						{
							bVelX2 += _self.movedVelX;
							bVelY2 += _self.movedVelY;
						}
							
						if(moveXFlag)
						{
							moveX = min(abs(bVelX2),1)*sign(bVelX2);
						}
						if(moveYFlag)
						{
							moveY = min(abs(bVelY2),1)*sign(bVelY2);
						}
							
						var prevX = position.X,
							prevY = position.Y;
						self.Collision_MovingSolid(moveX,moveY, _self);
						var posDifX = position.X-prevX,
							posDifY = position.Y-prevY;
							
						if(moveXFlag) { movedVelX += posDifX; }
						if(moveYFlag) { movedVelY += posDifY; }
						
						if(avoidClipping)
						{
							var bDifX = bVX-posDifX,
								bDifY = bVY-posDifY;
							if(moveXFlag2 && bDifX != 0)
							{
								bVX -= bDifX;
							}
							if(moveYFlag2 && bDifY != 0)
							{
								bVY -= bDifY;
							}
						}
					}
				}
			}
			ds_list_clear(entityList);
		}
		
		x += bVX;
		y += bVY;
		
		maxSpeedX = max(maxSpeedX-1,0);
		maxSpeedY = max(maxSpeedY-1,0);
	}
	
	tempIgnoredEnt = noone;
}
