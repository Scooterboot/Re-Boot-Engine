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

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
var miX = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2,
	miY = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
mapIcon = obj_Map.CreateMapIcon(sprt_MapIcon_Save, 0, miX, miY,,,,false);

function UpdateMapIcon()
{
	for(var i = 0; i < array_length(global.mapArea); i++)
	{
		for(var j = 0; j < ds_list_size(global.mapArea[i].icons); j++)
		{
			var _icon = global.mapArea[i].icons[| j];
			if(is_array(_icon) && _icon[MapIconInd.SpriteIndex] == mapIcon[MapIconInd.SpriteIndex])
			{
				ds_list_delete(global.mapArea[i].icons,j);
			}
		}
	}
	
	var msSizeW = global.mapSquareSizeW,
		msSizeH = global.mapSquareSizeH;
	mapIcon[MapIconInd.XPos] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
	mapIcon[MapIconInd.YPos] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
	
	ds_list_add(global.rmMapArea.icons, mapIcon);
}

shipIcon = obj_Map.CreateMapIcon(sprt_MapIcon_Ship, 0, miX, miY,,,,false);

mapListIndex = -1;
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
	}
}