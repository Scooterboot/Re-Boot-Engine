if(instance_exists(page))
{
	if(ds_exists(page.modalElements, ds_type_list))
	{
		var pos = ds_list_find_index(page.modalElements,id);
		ds_list_delete(page.modalElements,pos);
	}
	if(ds_exists(page.elements, ds_type_list))
	{
		var pos = ds_list_find_index(page.elements,id);
		ds_list_delete(page.elements,pos);
	}
}

if(instance_exists(containerEle) && ds_exists(containerEle.nestedEle, ds_type_list))
{
	var pos = ds_list_find_index(containerEle.nestedEle,id);
	ds_list_delete(containerEle.nestedEle,pos);
}
if(ds_exists(nestedEle, ds_type_list))
{
	for(var i = ds_list_size(nestedEle)-1; i >= 0; i--)
	{
		instance_destroy(nestedEle[| i]);
	}
	ds_list_destroy(nestedEle);
}
