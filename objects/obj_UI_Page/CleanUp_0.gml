if(instance_exists(creatorUI) && ds_exists(creatorUI.pageList, ds_type_list))
{
	var pos = ds_list_find_index(creatorUI.pageList,id);
	ds_list_delete(creatorUI.pageList,pos);
}

if(ds_exists(elements, ds_type_list))
{
	for(var i = ds_list_size(elements)-1; i >= 0; i--)
	{
		instance_destroy(elements[| i]);
	}
	ds_list_destroy(elements);
}
if(ds_exists(modalElements, ds_type_list))
{
	ds_list_destroy(modalElements);
}
