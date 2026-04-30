/// @description Initialize
event_inherited();
//hatchID = -1;
//hatchID_Global = -1;
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
justHit = false;
function DamageHatch(_dmg)
{
	if(!immune && !justHit)
	{
		hitPoints -= _dmg;
		if(hitPoints > 0)
		{
			hitAnim = 8;
		}
		justHit = true;
	}
}

unlocked = true;
function UnlockCondition()
{
	return true;
}

mapIconIndex = 0;

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
var miX = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2,
	miY = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;
mapIcon = obj_Map.CreateMapIcon(sprt_MapIcon_Door, mapIconIndex, miX, miY, image_xscale,image_yscale,image_angle);

mapListIndex = -1;
function UpdateMapIcon()
{
	if(global.rmMapArea != noone && ds_exists(global.rmMapArea.icons,ds_type_list))
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