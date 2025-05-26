/// @description Initialize

image_speed = 0;

back = instance_create_layer(x,y,"NPCs_bg",obj_SaveStation_Back);

beginSave = 0;
saving = 0;
maxSave = 170;//180;
saveCooldown = 0;

gameSavedText = "GAME SAVED";

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
mapIcon = array_create(7);
mapIcon[0] = sprite_get_name(sprt_MapIcon_Save);
mapIcon[1] = 0;
mapIcon[2] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
mapIcon[3] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
mapIcon[4] = 1;
mapIcon[5] = 1;
mapIcon[6] = 0;
mapIcon[7] = false;

function UpdateMapIcon()
{
	for(var i = 0; i < array_length(global.mapArea); i++)
	{
		for(var j = 0; j < ds_list_size(global.mapArea[i].icons); j++)
		{
			var _icon = global.mapArea[i].icons[| j];
			if(is_array(_icon) && _icon[0] == mapIcon[0])
			{
				ds_list_delete(global.mapArea[i].icons,j);
			}
		}
	}
	
	var msSizeW = global.mapSquareSizeW,
		msSizeH = global.mapSquareSizeH;
	mapIcon[2] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
	mapIcon[3] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
	
	ds_list_add(global.rmMapArea.icons, mapIcon);
}