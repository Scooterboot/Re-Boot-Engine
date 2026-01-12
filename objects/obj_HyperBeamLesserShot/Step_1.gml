/// @description 
event_inherited();

if(!isWave)
{
	projStyle = ProjStyle.Spazer;
	amplitude = 14;
}
else
{
	amplitude = 16 / max(scr_ceil(waveStyle/2),1);
}
