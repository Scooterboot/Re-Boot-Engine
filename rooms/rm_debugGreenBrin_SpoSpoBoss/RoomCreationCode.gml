var music = global.music_MiniBoss;

if(global.BossDowned("SporeSpawn"))
{
	music = global.music_ItemRoom;
}

scr_InitRoom(music,MapArea.Brinstar, 33,2, 96,-16);