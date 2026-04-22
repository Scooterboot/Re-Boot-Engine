/// @description Initialize

imSpeed = image_speed;

itemName = "";
//itemID = -1;
collected = false;

itemHeader = "";
itemDesc = "";
isExpansion = false;
expanHeader = "";
expanDesc = "";

function CollectItem(player) {}

isMajorItem = false;

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
var miX = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2,
	miY = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
mapIcon = obj_Map.CreateMapIcon(sprite_get_name(sprt_MapIcon_Item), 1, miX, miY);

mapListIndex = -1;
mapIconHidden = false;
function UpdateMapIcon()
{
	if(global.rmMapArea != noone && ds_exists(global.rmMapArea.icons,ds_type_list) && !mapIconHidden)
	{
		mapListIndex = FindArrayIndexInList(global.rmMapArea.icons, mapIcon, MapIconInd.ImageIndex);
		if(mapListIndex < 0)
		{
			ds_list_add(global.rmMapArea.icons, mapIcon);
			mapListIndex = FindArrayIndexInList(global.rmMapArea.icons, mapIcon, MapIconInd.ImageIndex);
		}
		else
		{
			global.rmMapArea.icons[| mapListIndex] = mapIcon;
		}
	}
}