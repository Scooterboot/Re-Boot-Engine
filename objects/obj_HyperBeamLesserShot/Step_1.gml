/// @description 
event_inherited();

if(!isWave)
{
	aiStyle = 2;
	amplitude = 14;
}
else
{
	amplitude = 16 / max(scr_ceil(waveStyle/2),1);
}
