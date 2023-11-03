var music = global.music_BossTension;
if(global.BossDowned("Kraid"))
{
	music = global.music_BrinstarRed;
}

scr_InitRoom(music,sprt_Map_DebugRooms,25,4);
scr_SetParallax("Background",0.5,0.5);