/// @description Initialize

breakType = 0;
blockIndex = noone;
respawnTime = 100;
initialTime = 100;
image_speed = 0;
image_index = 0;
frameCounter = -1;

function SetExtraRespawnVars(_respBlock) {}

entityList = ds_list_create();
function checkEntity(_x, _y)
{
	var _num = instance_place_list(_x, _y, obj_Entity, entityList, false);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			var entity = entityList[| i];
			if(instance_exists(entity) && array_contains_ext(entity.solids, ColType_Solid, false))
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
				
				if(tileCollide)
				{
					ds_list_clear(entityList);
					return true;
				}
			}
		}
		ds_list_clear(entityList);
	}
	return false;
}
