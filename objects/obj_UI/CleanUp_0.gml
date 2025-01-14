/// @description 

if(ds_exists(panelList, ds_type_list))
{
	for(var i = 0; i < ds_list_size(panelList); i++)
	{
		instance_destroy(panelList[| i]);
	}
	ds_list_destroy(panelList);
}