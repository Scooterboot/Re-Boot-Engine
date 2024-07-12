/// @description Initialize
event_inherited();

map = global.rmMapArea;
mapIndex = global.rmMapIndex;

mapAreaText[MapArea.Crateria] = "CRATERIA";
mapAreaText[MapArea.WreckedShip] = "WRECKED SHIP";
mapAreaText[MapArea.Brinstar] = "BRINSTAR";
mapAreaText[MapArea.Norfair] = "NORFAIR";
mapAreaText[MapArea.Maridia] = "MARIDIA";
mapAreaText[MapArea.Tourian] = "TOURIAN";

initMessage = false;
stationMessage = " MAP UPDATED";

Condition = function()
{
	return map != noone && !map.stationUsed;
}
Interact = function()
{
	if(!initMessage)
	{
		stationMessage = mapAreaText[mapIndex]+stationMessage;
		initMessage = true;
	}
	if(map != noone && mapIndex >= 0)
	{
		if(activeTime == activeTimeMax-1)
		{
			map.stationUsed = true;
			obj_PauseMenu.isPaused = true;
		}
	}
}