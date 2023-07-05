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

function UpdatePosition(_x,_y)
{
	// round x and y just in case
	x = scr_round(x);
	y = scr_round(y);
	
	var newPosX = scr_round(_x),
		newPosY = scr_round(_y);
	
	var bVelX = newPosX-x,
		bVelY = newPosY-y;
	
	//isSolid = false;
	//asset_remove_tags(obj_MovingTile,"IMovingSolid",asset_object);
	//asset_remove_tags(obj_MovingSlope,"IMovingSolid",asset_object);
	//asset_remove_tags(obj_MovingSlope_4th,"IMovingSolid",asset_object);
	
	var num = instance_place_list(newPosX,newPosY,obj_Entity,entityList,false);
	
		num += instance_place_list(x,y-1,obj_Entity,entityList,false);
		num += instance_place_list(x,y+1,obj_Entity,entityList,false);
		num += instance_place_list(x-1,y,obj_Entity,entityList,false);
		num += instance_place_list(x+1,y,obj_Entity,entityList,false);
	
		num += instance_place_list(x-1,y-1,obj_Entity,entityList,false);
		num += instance_place_list(x+1,y-1,obj_Entity,entityList,false);
		num += instance_place_list(x-1,y+1,obj_Entity,entityList,false);
		num += instance_place_list(x+1,y+1,obj_Entity,entityList,false);
	for(var i = 0; i < num; i++)
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
				
				if(place_meeting(newPosX,y,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(x,newPosY,entity)))
				{
					moveXFlag = true;
				}
				if(place_meeting(x,newPosY,entity) || (place_meeting(newPosX,newPosY,entity) && !place_meeting(newPosX,y,entity)))
				{
					moveYFlag = true;
				}
				
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
					if(moveXFlag)
					{
						moveX -= shiftedVelX;
					}
					if(moveYFlag)
					{
						moveY -= shiftedVelY;
					}
					var prevShiftX = shiftedVelX,
						prevShiftY = shiftedVelY;
					
					Collision_MovingSolid(moveX,moveY,8,8);
					
					shiftedVelX = moveXFlag ? (x-xprevious) : prevShiftX;
					shiftedVelY = moveYFlag ? (y-yprevious) : prevShiftY;
				}
			}
		}
	}
	ds_list_clear(entityList);
	
	x = newPosX;
	y = newPosY;
	
	//isSolid = true;
	//asset_add_tags(obj_MovingTile,"IMovingSolid",asset_object);
	//asset_add_tags(obj_MovingSlope,"IMovingSolid",asset_object);
	//asset_add_tags(obj_MovingSlope_4th,"IMovingSolid",asset_object);
}
