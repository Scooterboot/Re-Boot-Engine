/// @description 

lhc_inherit_interface("IMovingSolid");

isSolid = true;

canGrip = true;
grappleCollision = true;

entityList = ds_list_create();

ignoredEntity = noone;

function IsEntity_Top(entity) { return place_meeting(x,y-1,entity); }
function IsEntity_Bottom(entity) { return place_meeting(x,y+1,entity); }
function IsEntity_Left(entity) { return place_meeting(x-1,y,entity); }
function IsEntity_Right(entity) { return place_meeting(x+1,y,entity); }

function UpdatePosition(_x,_y, avoidClipping = false)
{
	// round x and y just in case
	x = scr_round(x);
	y = scr_round(y);
	
	var newPosX = scr_round(_x),
		newPosY = scr_round(_y);
	
	var bVelX = newPosX-x,
		bVelY = newPosY-y;
	
	collision_rectangle_list(
		min(bbox_left-1,bbox_left+bVelX),
		min(bbox_top-1,bbox_top+bVelY),
		max(bbox_right+1,bbox_right+bVelX),
		max(bbox_bottom+1,bbox_bottom+bVelY),
		obj_Entity,true,true,entityList,false);
	
	for(var i = 0; i < ds_list_size(entityList); i++)
	{
		if(instance_exists(entityList[| i]) && array_contains(entityList[| i].solids,"IMovingSolid") && entityList[| i] != ignoredEntity)
		{
			var entity = entityList[| i];
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
			if(tileCollide)
			{
				var moveX = 0,
					moveY = 0;
				var moveXFlag = false,
					moveYFlag = false;
				
				var edgeTop = IsEntity_Top(entity),
					edgeBottom = IsEntity_Bottom(entity),
					edgeLeft = IsEntity_Left(entity),
					edgeRight = IsEntity_Right(entity);
				
				var entityEdgeBottomX = entity.MoveStickBottom_X(id),
					entityEdgeBottomY = entity.MoveStickBottom_Y(id),
					entityEdgeTopX = entity.MoveStickTop_X(id),
					entityEdgeTopY = entity.MoveStickTop_Y(id),
					entityEdgeRightX = entity.MoveStickRight_X(id),
					entityEdgeRightY = entity.MoveStickRight_Y(id),
					entityEdgeLeftX = entity.MoveStickLeft_X(id),
					entityEdgeLeftY = entity.MoveStickLeft_Y(id);
				
				if ((edgeTop && entityEdgeBottomX) ||
					(edgeBottom && entityEdgeTopX) ||
					(edgeLeft && (entityEdgeRightX || bVelX < 0)) || 
					(edgeRight && (entityEdgeLeftX || bVelX > 0)))
				{
					moveXFlag = true;
				}
				if ((edgeTop && (entityEdgeBottomY || bVelY < 0)) || 
					(edgeBottom && (entityEdgeTopY || bVelY > 0)) ||
					(edgeLeft && entityEdgeRightY) || 
					(edgeRight && entityEdgeLeftY))
				{
					moveYFlag = true;
				}
				
				var moveXFlag2 = false,
					moveYFlag2 = false;
				if(place_meeting(newPosX,y,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(x,newPosY,entity)))
				{
					moveXFlag = true;
					moveXFlag2 = true;
				}
				if(place_meeting(x,newPosY,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(newPosX,y,entity)))
				{
					moveYFlag = true;
					moveYFlag2 = true;
				}
				
				if(moveXFlag)
				{
					moveX = bVelX;
				}
				if(moveYFlag)
				{
					moveY = bVelY;
				}
				
				with(entity)
				{
					if(moveXFlag) { moveX -= movedVelX; }
					if(moveYFlag) { moveY -= movedVelY; }
					
					Collision_MovingSolid(moveX,moveY);
					
					if(moveXFlag) { movedVelX = (x-xprevious); }
					if(moveYFlag) { movedVelY = (y-yprevious); }
					
					if(moveXFlag2 && abs(x-xprevious) < abs(bVelX))
					{
						bVelX = (x-xprevious);
					}
					if(moveYFlag2 && abs(y-yprevious) < abs(bVelY))
					{
						bVelY = (y-yprevious);
					}
				}
			}
		}
	}
	ds_list_clear(entityList);
	
	if(avoidClipping)
	{
		x += bVelX;
		y += bVelY;
	}
	else
	{
		x = newPosX;
		y = newPosY;
	}
}
