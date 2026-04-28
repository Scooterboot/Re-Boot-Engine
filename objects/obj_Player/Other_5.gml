
if(ds_exists(afterImageList,ds_type_list) && ds_list_size(afterImageList) > 0)
{
	for(var i = 0, len = ds_list_size(afterImageList); i < len; i++)
	{
		afterImageList[| i].Clear();
	}
}
