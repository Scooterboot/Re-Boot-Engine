if(ds_exists(pageList, ds_type_list))
{
	for(var i = ds_list_size(pageList)-1; i >= 0; i--)
	{
		instance_destroy(pageList[| i]);
	}
	ds_list_destroy(pageList);
}
