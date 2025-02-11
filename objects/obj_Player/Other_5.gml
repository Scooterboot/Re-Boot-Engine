
if(ds_exists(afterImageList,ds_type_list) && ds_list_size(afterImageList) > 0)
{
	for(var i = 0; i < ds_list_size(afterImageList); i++)
	{
		afterImageList[| i].Clear();
		//ds_list_delete(afterImageList,i);
	}
}