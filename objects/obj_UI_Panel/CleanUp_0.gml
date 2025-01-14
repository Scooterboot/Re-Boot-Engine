/// @description 

if(ds_exists(buttonList, ds_type_list))
{
	for(var i = 0; i < ds_list_size(buttonList); i++)
	{
		instance_destroy(buttonList[| i]);
	}
	ds_list_destroy(buttonList);
}

if(instance_exists(creator) && ds_exists(creator.panelList, ds_type_list))
{
	var pos = ds_list_find_index(creator.panelList,id);
	ds_list_delete(creator.panelList,pos);
}

if(surface_exists(panelSurf))
{
	surface_free(panelSurf);
}