
if(instance_exists(creatorUI))
{
	var pos = array_find_index_by_value(creatorUI.pageArr, id);
	array_delete(creatorUI.pageArr, pos, 1);
}

for(var i = array_length(elements)-1; i >= 0; i--)
{
	instance_destroy(elements[i]);
}
