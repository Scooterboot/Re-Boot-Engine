// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_OpenDoor(_x,_y,_type)
{
	if(place_meeting(_x,_y,obj_DoorHatch) && _type > -1)
	{
		var door = instance_place(_x,_y,obj_DoorHatch);
		if(instance_exists(door) && door.object_index == obj_DoorHatch)
		{
			door.hitPoints -= 1;
		}
		if(_type == 1 || _type == 2 || _type == 4)
		{
			if(_type == 2 || _type == 4)
			{
				scr_DamageDoor(_x,_y,obj_DoorHatch_Missile,5);
			}
			else
			{
				scr_DamageDoor(_x,_y,obj_DoorHatch_Missile,1);
			}
		}
		if(_type == 2 || _type == 4)
		{
			scr_DamageDoor(_x,_y,obj_DoorHatch_Super,1);
		}
		if(_type == 3 || _type == 4)
		{
			scr_DamageDoor(_x,_y,obj_DoorHatch_Power,1);
		}
	}
}
function scr_DamageDoor(_x,_y,_objIndex,_dmg)
{
	var _list = ds_list_create();
	var _num = instance_place_list(_x,_y,_objIndex,_list,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			_list[| i].Damage(_dmg);
		}
	}
	ds_list_destroy(_list);
}