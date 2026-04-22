/// @description Add to collected items list

if(collected && itemID != -1)
{
	ds_list_add(global.collectedItemList,room_get_name(room)+"_"+itemName+"_"+string(itemID));
	var anim = instance_create_layer(x,y,layer,obj_Item_PickupAnim);
	anim.sprite_index = sprite_index;
	
	var flag = 0;
	for(var i = 0; i < instance_number(obj_Item); i++)
	{
		var item = instance_find(obj_Item,i);
		if(instance_exists(item) && item != id)
		{
			var itemX = obj_Map.GetMapPosX(item.x),
				itemY = obj_Map.GetMapPosX(item.y);
			if (item.mapIcon[MapIconInd.XPos] == mapIcon[MapIconInd.XPos] && 
				item.mapIcon[MapIconInd.YPos] == mapIcon[MapIconInd.YPos] && !item.mapIconHidden)
			{
				if(isMajorItem)
				{
					if(item.isMajorItem)
					{
						flag = 1;
						break;
					}
					else
					{
						flag = 2;
					}
				}
				else
				{
					flag = 1;
					break;
				}
			}
		}
	}
	
	if(flag == 0)
	{
		mapIcon[MapIconInd.ImageIndex] = 2;
		UpdateMapIcon();
	}
	if(flag == 2)
	{
		mapIcon[MapIconInd.ImageIndex] = 1;
		UpdateMapIcon();
	}
}