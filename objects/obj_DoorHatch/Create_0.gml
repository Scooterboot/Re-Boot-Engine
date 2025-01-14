/// @description Initialize
event_inherited();
hatchID = -1;
hatchID_Global = -1;
//idCheck = false;

image_index = 0;
image_speed = 0;

frame = 0;
frameCounter = 0;

destroy = false;
falseDestroy = false;

hitPoints = 1;

hitAnim = 0;

immune = false;
function DamageHatch(_dmg)
{
	if(!immune)
	{
		hitPoints -= _dmg;
		if(hitPoints > 0)
		{
			hitAnim = 8;
		}
	}
}

unlocked = true;
unlockAnim = 0;
function UnlockCondition()
{
	return true;
}

mapIconIndex = 0;

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;

mapIcon = array_create(7);
mapIcon[0] = sprite_get_name(sprt_MapIcon_Door);
mapIcon[1] = mapIconIndex;
mapIcon[2] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
mapIcon[3] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
mapIcon[4] = image_xscale;
mapIcon[5] = image_yscale;
mapIcon[6] = image_angle;

mapListIndex = -1;

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
	if(global.rmMapArea != noone && ds_exists(global.rmMapArea.icons,ds_type_list))
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