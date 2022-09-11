var music = global.music_BossTension;
if(global.BossDowned("Kraid"))
{
	music = global.music_ItemRoom;
}

scr_InitRoom(music,sprt_Map_DebugRooms,32,4, 32,0);
scr_BGParallax("Background",0.5,0.5);