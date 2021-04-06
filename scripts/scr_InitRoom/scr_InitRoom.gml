/// @description scr_InitRoom
/// @param mapSprt
/// @param mapX
/// @param mapY
/// @param music
/// @param heated=false
function scr_InitRoom() {

	var mapSprt = argument[0],
	mapX = argument[1],
	mapY = argument[2],
	music = argument[3];

	var heated = false;
	if(argument_count > 4)
	{
		heated = argument[4];
	}

	global.rmMapSprt = mapSprt;
	global.rmMapX = mapX;
	global.rmMapY = mapY;

	global.rmMusic = music;

	global.rmHeated = heated;


}
