/// @description 

xRayHide = false;

isSolid = true;

entityList = ds_list_create();

ignoredEntity = noone;
tempIgnoredEnt = noone;

function IsEntity_Top(entity)
{
	var this = id;
	with(entity)
	{
		return place_meeting(x,y+1,this) || place_meeting(position.X,position.Y+1,this);
	}
	return place_meeting(x,y-1,entity);
}

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
		
		/*var elNum = collision_rectangle_list(
					min(bbox_left,bbox_left+bVX),
					min(bbox_top-1,bbox_top+bVY),
					max(bbox_right-1,bbox_right-1+bVX),
					max(bbox_bottom-1,bbox_bottom-1+bVY),
					obj_Entity,true,true,entityList,false);*/
		var elNum = collision_rectangle_list(bbox_left,bbox_top-2,bbox_right-1,bbox_bottom-1,obj_Entity,true,true,entityList,true);
	
		if(elNum > 0)
		{
			for(var i = 0; i < elNum; i++)
			{
				if(instance_exists(entityList[| i]) && entityList[| i].CanPlatformCollide() && entityList[| i] != ignoredEntity && entityList[| i] != tempIgnoredEnt)
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
							moveYFlag = false,
							//moveXFlag2 = false,
							moveYFlag2 = false;
				
						var edgeTop = self.IsEntity_Top(entity);
				
						var entityEdgeBottomX = entity.MoveStickBottom_X(id),
							entityEdgeBottomY = entity.MoveStickBottom_Y(id);
				
						if (edgeTop && entityEdgeBottomX)
						{
							moveXFlag = true;
						}
						if (edgeTop && (entityEdgeBottomY || bVY < 0))
						{
							moveYFlag = true;
							if((edgeTop && bVY < 0))
							{
								moveYFlag2 = true;
							}
						}
				
						if(entity.bb_bottom() <= bbox_top)
						{
							if(place_meeting(x+bVX,y,entity) || (place_meeting(x+bVX,y+bVY,entity) && !place_meeting(x,y+bVY,entity)))
							{
								moveXFlag = true;
							}
							if(place_meeting(x,y+bVY,entity) || (place_meeting(x+bVX,y+bVY,entity) && !place_meeting(x+bVX,y,entity)))
							{
								moveYFlag = true;
								moveYFlag2 = true;
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
								//if(moveXFlag2 && bDifX != 0)
								//{
								//	bVX -= bDifX;
								//}
								if(moveYFlag2 && bDifY != 0)
								{
									bVY -= bDifY;
								}
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