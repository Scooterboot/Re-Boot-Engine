/// @description 

shutterID = 0;

init = false;

image_index = 0;
image_speed = 0;

function GetGates()
{
	var gates = array_create(0),
		gnum = 0;
	
	var num = instance_number(obj_ShutterGate);
	for(var i = 0; i < num; i++)
	{
		var sGate = instance_find(obj_ShutterGate,i);
		if(instance_exists(sGate) && sGate.shutterID == shutterID)
		{
			gates[gnum] = sGate;
			gnum++;
		}
	}
	return gates;
}

gates = array_create(0);
gateStartedOpen = array_create(0);

entityDetected = false;

entityList = ds_list_create();
function GetEntity()
{
	var num = instance_place_list(x,y-2,obj_Entity,entityList,true);
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