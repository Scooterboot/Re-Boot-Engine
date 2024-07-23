/// @description Initialize

imSpeed = image_speed;

itemName = "";
itemID = -1;
collected = false;

itemHeader = "";
itemDesc = "";
isExpansion = false;
expanHeader = "";
expanDesc = "";

function CollectItem(player) {}

isMajorItem = false;

var msSize = global.mapSquareSize;
mapIcon = array_create(7);
mapIcon[0] = sprite_get_name(sprt_MapIcon_Item);
mapIcon[1] = 1;
mapIcon[2] = obj_Map.GetMapPosX(x) * msSize + msSize/2;
mapIcon[3] = obj_Map.GetMapPosY(y) * msSize + msSize/2;
mapIcon[4] = 1;
mapIcon[5] = 1;
mapIcon[6] = 0;

mapListIndex = -1;

mapIconHidden = false;

function FindArrayIndexInList(_list,_array)
{
	for(var i = 0; i < ds_list_size(_list); i++)
	{
		if(is_array(_list[| i]))
		{
			var _listArray = _list[| i];
			var _flag = false;
			for(var j = 0; j < array_length(_listArray); j++)
			{
				if(_listArray[j] != _array[j] && j != 1) 
				// specifically skipping [1] because it's the icon's image index
				{
					_flag = true;
					break;
				}
			}
			if(!_flag)
			{
				return i;
			}
		}
	}
	return -1;
}
function UpdateMapIcon()
{
	if(global.rmMapArea != noone && ds_exists(global.rmMapArea.icons,ds_type_list) && !mapIconHidden)
	{
		mapListIndex = FindArrayIndexInList(global.rmMapArea.icons, mapIcon);
		if(mapListIndex < 0)
		{
			ds_list_add(global.rmMapArea.icons, mapIcon);
			mapListIndex = FindArrayIndexInList(global.rmMapArea.icons, mapIcon);
		}
		else
		{
			global.rmMapArea.icons[| mapListIndex] = mapIcon;
		}
		
		//show_debug_message(string(ds_list_size(global.rmMapArea.icons)));
	}
}