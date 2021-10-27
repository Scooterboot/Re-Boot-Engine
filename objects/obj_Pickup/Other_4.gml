/// @description Destroy if already collected

if(itemID != -1 && !collected && ds_list_find_index(global.collectedItemList,room_get_name(room)+"_"+itemName+"_"+string(itemID)) != -1)
{
	instance_destroy();
}