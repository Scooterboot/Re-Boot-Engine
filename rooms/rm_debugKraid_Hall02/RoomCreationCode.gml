var music = global.music_BossTension;
if(global.BossDowned("Kraid"))
{
	//music = global.music_BrinstarRed;
	music = global.music_KraidsLair;
}

scr_InitRoom(music,MapArea.Brinstar, 44,11);
scr_SetParallax("Background",0.5,0.5);