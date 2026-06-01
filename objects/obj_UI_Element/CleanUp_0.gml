
if(instance_exists(page))
{
	var pos = array_find_index_by_value(page.modalElements, id);
	if(pos >= 0)
	{
		array_delete(page.modalElements, pos, 1);
	}
	
	pos = array_find_index_by_value(page.elements, id);
	if(pos >= 0)
	{
		array_delete(page.elements, pos, 1);
	}
}

if(instance_exists(containerEle))
{
	var pos = array_find_index_by_value(containerEle.nestedEle, id);
	if(pos >= 0)
	{
		array_delete(containerEle.nestedEle, pos, 1);
	}
}
for(var i = array_length(nestedEle)-1; i >= 0; i--)
{
	instance_destroy(nestedEle[i]);
}
