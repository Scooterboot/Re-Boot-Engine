var music = global.music_BossTension;
if(global.BossDowned("Kraid"))
{
	music = global.music_BrinstarRed;
}

scr_InitRoom(music,MapArea.Brinstar,44,10);
scr_SetParallax("Background",0.5,0.5);