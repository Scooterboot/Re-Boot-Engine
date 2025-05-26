/// @description 

shutterID = 0;

init = false;

image_index = 0;
image_speed = 0;

gates = array_create(0);

entityDetected = false;

entityList = ds_list_create();
function GetEntity()
{
	var num = instance_place_list(x,y,obj_Entity,entityList,true);
	for(var i = 0; i < num; i++)
	{
		var entity = entityList[| i];
		if(!instance_exists(entity))
		{
			continue;
		}
		if(object_is_ancestor(entity.object_index,obj_Projectile))
		{
			continue;
		}
		if(object_is_ancestor(entity.object_index,obj_NPC) && !entity.tileCollide)
		{
			continue;
		}
		ds_list_clear(entityList);
		return entity;
	}
	ds_list_clear(entityList);
	return noone;
}

frame = 0;
frameCounter = 0;