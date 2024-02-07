/// @description 

lhc_inherit_interface("IPlatform");
xRayHide = false;

isSolid = true;

entityList = ds_list_create();

ignoredEntity = noone;

function IsEntity_Top(entity) { return place_meeting(x,y-1,entity); }

function UpdatePosition(_x,_y)
{
	// round x and y just in case
	x = scr_round(x);
	y = scr_round(y);
	
	var newPosX = scr_round(_x),
		newPosY = scr_round(_y);
	
	var bVelX = newPosX-x,
		bVelY = newPosY-y;
	
	collision_rectangle_list(
		min(bbox_left,bbox_left+bVelX),
		min(bbox_top-1,bbox_top+bVelY),
		max(bbox_right,bbox_right+bVelX),
		max(bbox_bottom,bbox_bottom+bVelY),
		obj_Entity,true,true,entityList,false);
	
	for(var i = 0; i < ds_list_size(entityList); i++)
	{
		if(instance_exists(entityList[| i]) && entityList[| i].CanPlatformCollide() && entityList[| i] != ignoredEntity)
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
			if(entity.passthroughMovingSolids || place_meeting(x,y,entity))
			{
				tileCollide = false;
			}
			if(tileCollide)
			{
				var moveX = 0,
					moveY = 0;
				var moveXFlag = false,
					moveYFlag = false;
				
				var edgeTop = IsEntity_Top(entity);
				
				var entityEdgeBottomX = entity.MoveStickBottom_X(id),
					entityEdgeBottomY = entity.MoveStickBottom_Y(id);
				
				if (edgeTop && entityEdgeBottomX)
				{
					moveXFlag = true;
				}
				if (edgeTop && (entityEdgeBottomY || bVelY < 0))
				{
					moveYFlag = true;
				}
				
				if(entity.bbox_bottom <= bbox_top)
				{
					if(place_meeting(newPosX,y,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(x,newPosY,entity)))
					{
						moveXFlag = true;
					}
					if(place_meeting(x,newPosY,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(newPosX,y,entity)))
					{
						moveYFlag = true;
					}
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
					
					Collision_MovingSolid(moveX,moveY,8,8);
					
					if(moveXFlag) { movedVelX = (x-xprevious); }
					if(moveYFlag) { movedVelY = (y-yprevious); }
				}
			}
		}
	}
	ds_list_clear(entityList);
	
	x = newPosX;
	y = newPosY;
}