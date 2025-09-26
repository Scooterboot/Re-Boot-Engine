
if(!audio_is_playing(snd_ScanVisor))
{
	scanSound = audio_play_sound(snd_ScanVisor,0,true,1);
	audio_sound_gain(scanSound,0.375,2000);
}
else
{
	if(global.GamePaused())
	{
		audio_pause_sound(snd_ScanVisor);
	}
	else
	{
		audio_resume_sound(snd_ScanVisor);
	}
}

if(!kill)
{
	scanAlpha = min(scanAlpha + 0.1, 1);
	
	x = clamp(x, 0, global.resWidth);
	y = clamp(y, 0, global.resHeight);
}
else
{
	scanAlpha = max(scanAlpha - 0.1, 0);
	
	if(scanAlpha <= 0)
	{
		instance_destroy();
	}
}