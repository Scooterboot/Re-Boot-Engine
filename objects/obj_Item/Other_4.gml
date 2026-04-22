/// @description Destroy if already collected

if(itemID != -1 && !collected && ds_list_find_index(global.collectedItemList,room_get_name(room)+"_"+itemName+"_"+string(itemID)) != -1)
{
	instance_destroy();
	exit;
}

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
mapIcon[MapIconInd.XPos] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
mapIcon[MapIconInd.YPos] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;

if(isMajorItem)
{
	mapIcon[MapIconInd.ImageIndex] = 0;
}

var m = FindArrayIndexInList(global.rmMapArea.icons, mapIcon, MapIconInd.ImageIndex);
if(m != -1)
{
	mapIcon[MapIconInd.ImageIndex] = min(mapIcon[MapIconInd.ImageIndex], global.rmMapArea.icons[| m][MapIconInd.ImageIndex]);
}

UpdateMapIcon();