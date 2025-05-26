/// @description Destroy if already collected

if(itemID != -1 && !collected && ds_list_find_index(global.collectedItemList,room_get_name(room)+"_"+itemName+"_"+string(itemID)) != -1)
{
	instance_destroy();
	exit;
}

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
mapIcon[2] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
mapIcon[3] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;

if(isMajorItem)
{
	mapIcon[1] = 0;
}

var m = FindArrayIndexInList(global.rmMapArea.icons, mapIcon);
if(m != -1)
{
	mapIcon[1] = min(mapIcon[1], global.rmMapArea.icons[| m][1]);
}

UpdateMapIcon();