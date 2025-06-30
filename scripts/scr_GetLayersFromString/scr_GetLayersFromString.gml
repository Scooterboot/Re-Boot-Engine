// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_GetLayersFromString()
{
	/// @description scr_GetLayersFromString
	/// @param subString
	
	var _lay = layer_get_all(),
		//_list = ds_list_create();
		num = 0;
	
	var result = [];
	
	for(var i = 0; i < array_length(_lay); i++)
	{
		if(!layer_exists(_lay[i]))
		{
			continue;
		}
		for(var j = 0; j < argument_count; j++)
		{
			if(string_count(argument[j],layer_get_name(_lay[i])) > 0)
			{
				//ds_list_add(_list,_lay[i]);
				result[num] = _lay[i];
				num++;
				break;
			}
		}
	}
	
	/*for(var i = 0; i < ds_list_size(_list); i++)
	{
		result[i] = ds_list_find_value(_list,i);
	}
	
	ds_list_destroy(_list);*/
	
	return result;
}