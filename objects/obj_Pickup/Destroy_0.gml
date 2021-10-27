/// @description Add to collected items list

if(collected && itemID != -1)
{
	ds_list_add(global.collectedItemList,room_get_name(room)+"_"+itemName+"_"+string(itemID));
	var anim = instance_create_layer(x,y,layer,obj_Item_PickupAnim);
	anim.sprite_index = sprite_index;
}