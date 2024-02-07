/// @description 

if(global.gamePaused)
{
	exit;
}

/*
var player = instance_place(x,y-2,obj_Player);
if(!instance_exists(player))
{
	player = instance_place(x,y+2,obj_Player);
}
if(!instance_exists(player))
{
	player = instance_place(x+2,y,obj_Player);
}
if(!instance_exists(player))
{
	player = instance_place(x-2,y,obj_Player);
}

if(instance_exists(player))
{
	var _dir = image_angle + 180*(image_xscale < 0);
	
	player.shiftX += lengthdir_x(moveSpeed,_dir);
	player.shiftY += lengthdir_y(moveSpeed,_dir);
}
*/

var _dir = image_angle + 180*(image_xscale < 0);
var _velX = lengthdir_x(moveSpeed,_dir),
	_velY = lengthdir_y(moveSpeed,_dir);

collision_rectangle_list(bbox_left-1,bbox_top-1,bbox_right+1,bbox_bottom+1,obj_Entity,true,true,entityList,false);

for(var i = 0; i < ds_list_size(entityList); i++)
{
	if(instance_exists(entityList[| i]) && array_contains(entityList[| i].solids,"IMovingSolid"))
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