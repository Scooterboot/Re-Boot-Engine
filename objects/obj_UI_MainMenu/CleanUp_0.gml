/// @description 
event_inherited();

if(ds_exists(itemList,ds_type_list))
{
	ds_list_destroy(itemList);
}