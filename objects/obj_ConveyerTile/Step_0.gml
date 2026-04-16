/// @description 

if(global.GamePaused())
{
	exit;
}

var _dir = image_angle + 180*(image_xscale < 0);
var _velX = lengthdir_x(moveSpeed,_dir),
	_velY = lengthdir_y(moveSpeed,_dir);

collision_rectangle_list(bbox_left-1,bbox_top-1,bbox_right+1,bbox_bottom+1,obj_Entity,true,true,entityList,false);

for(var i = 0; i < ds_list_size(entityList); i++)
{
	if(instance_exists(entityList[| i]) && array_contains_ext(entityList[| i].solids,ColType_MovingSolid))
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
		if(tileCollide)
		{
			entity.shiftX += _velX;
			entity.shiftY += _velY;
		}
	}
}
ds_list_clear(entityList);
