/// @description Convert to blue door
var flag = false;
if(hatchID_Global != -1)
{
	if(ds_list_find_index(global.openHatchList,"global_hatchOpened_"+string(hatchID_Global)) != -1)
	{
		flag = true;
	}
}
else if(hatchID != -1)
{
	if(ds_list_find_index(global.openHatchList,room_get_name(room)+"_hatchOpened_"+string(hatchID)) != -1)
	{
		flag = true;
	}
}

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;

mapIcon[MapIconInd.ImageIndex] = mapIconIndex;
mapIcon[MapIconInd.XPos] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
mapIcon[MapIconInd.YPos] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
mapIcon[MapIconInd.XScale] = image_xscale;
mapIcon[MapIconInd.YScale] = image_yscale;
mapIcon[MapIconInd.Rotation] = image_angle;

if(flag)
{
	mapIconIndex = 0;
	mapIcon[MapIconInd.ImageIndex] = mapIconIndex;
	
	htc = instance_create_layer(x,y,layer,obj_DoorHatch_Blue);
	htc.image_index = image_index;
	htc.direction = direction;
	htc.image_angle = image_angle;
	htc.image_xscale = image_xscale;
	htc.image_yscale = image_yscale;
	htc.frame = frame;
	htc.mapIcon = mapIcon;
	falseDestroy = true;
	instance_destroy();
}

UpdateMapIcon();