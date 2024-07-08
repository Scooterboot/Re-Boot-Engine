var music = global.music_BossTension;
if(global.BossDowned("Kraid"))
{
	music = global.music_ItemRoom;
}

scr_InitRoom(music,MapArea.Brinstar,46,10, 32,0);
scr_SetParallax("Background",0.5,0.5);