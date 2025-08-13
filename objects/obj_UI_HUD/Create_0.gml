/// @description 

global.miniMapSizeX = 5;
global.miniMapSizeY = 3;

//controlGroups = "menu hud";
//InitControlVars(controlGroups);

currentMap = global.rmMapArea;
playerMapX = -1;
playerMapY = -1;
if(instance_exists(obj_Map))
{
	playerMapX = obj_Map.GetMapPosX(x);
	playerMapY = obj_Map.GetMapPosY(y);
}
prevPlayerMapX = playerMapX;
prevPlayerMapY = playerMapY;
pMapOffsetX = 0;
pMapOffsetY = 0;

prevArea = noone;

hudMapFlashAlpha = 0;
hudMapFlashNum = 1;