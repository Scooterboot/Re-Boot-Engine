function scr_InitRoom(music, mapIndex, mapX, mapY, mapPixX = 0, mapPixY = 0, heated = false)
{
	global.rmMusic = music;
	
	if(mapIndex >= 0)
	{
		global.rmMapIndex = mapIndex;
		global.rmMapArea = global.mapArea[mapIndex];
	}
	else
	{
		global.rmMapIndex = -1;
		global.rmMapArea = noone;
	}
	
	global.rmMapX = mapX;
	global.rmMapY = mapY;
	global.rmMapPixX = mapPixX;
	global.rmMapPixY = mapPixY;

	global.rmHeated = heated;
}