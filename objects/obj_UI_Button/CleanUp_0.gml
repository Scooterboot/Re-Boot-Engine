/// @description 

if(instance_exists(panel) && ds_exists(panel.buttonList,ds_type_list))
{
	var pos = ds_list_find_index(panel.buttonList,id);
	ds_list_delete(panel.buttonList,pos);
}

if(surface_exists(buttonSurf))
{
	surface_free(buttonSurf);
}