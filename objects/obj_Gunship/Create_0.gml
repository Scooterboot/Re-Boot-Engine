/// @description 

enum ShipState
{
	Idle,
	
	SaveDescend,
	SaveAnim,
	SaveAscend,
	
	Land,
	TakeOff
}

state = ShipState.Idle;

movePlayer = false;
moveY = 0;
moveYMax = 56;

saving = -20;
maxSave = 170;
gameSavedText = "GAME SAVED"+"\n\n"+"ENERGY & AMMO REPLENISHED";

idleAnim = 0;

hatchOpen = false;
hatchFrame = 0;
hatchFrameCounter = 0;
hatchY = 9;

lightGlow = 0;
lightGlowNum = 1;

visorLightGlow = 0;
visorLightGlowNum = 1;


block = instance_create_layer(x,y,layer,obj_Gunship_Mask);

var msSize = global.mapSquareSize;
mapIcon = array_create(7);
mapIcon[0] = sprite_get_name(sprt_MapIcon_Save);
mapIcon[1] = 0;
mapIcon[2] = obj_Map.GetMapPosX(x) * msSize + msSize/2;
mapIcon[3] = obj_Map.GetMapPosY(y) * msSize + msSize/2;
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
	
	var msSize = global.mapSquareSize;
	mapIcon[2] = obj_Map.GetMapPosX(x) * msSize + msSize/2;
	mapIcon[3] = obj_Map.GetMapPosY(y) * msSize + msSize/2;
	
	ds_list_add(global.rmMapArea.icons, mapIcon);
}

shipIcon = array_create(7);
shipIcon[0] = sprite_get_name(sprt_MapIcon_Ship);
shipIcon[1] = 0;
shipIcon[2] = obj_Map.GetMapPosX(x) * msSize + msSize/2;
shipIcon[3] = obj_Map.GetMapPosY(y) * msSize + msSize/2;
shipIcon[4] = 1;
shipIcon[5] = 1;
shipIcon[6] = 0;
shipIcon[7] = false;

mapListIndex = -1;

function FindArrayIndexInList(_list,_array)
{
	for(var i = 0; i < ds_list_size(_list); i++)
	{
		if(is_array(_list[| i]))
		{
			if(_list[| i][0] == _array[0])
			{
				return i;
			}
		}
	}
	return -1;
}
function UpdateShipIcon()
{
	if(global.rmMapArea != noone && ds_exists(global.rmMapArea.icons,ds_type_list))
	{
		mapListIndex = FindArrayIndexInList(global.rmMapArea.icons, shipIcon);
		if(mapListIndex < 0)
		{
			ds_list_add(global.rmMapArea.icons, shipIcon);
			mapListIndex = FindArrayIndexInList(global.rmMapArea.icons, shipIcon);
		}
		else
		{
			global.rmMapArea.icons[| mapListIndex] = shipIcon;
		}
		
		//show_debug_message(string(ds_list_size(global.rmMapArea.icons)));
	}
}