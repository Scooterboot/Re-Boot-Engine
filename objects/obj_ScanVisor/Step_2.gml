
if(!audio_is_playing(snd_ScanVisor))
{
	scanSound = audio_play_sound(snd_ScanVisor,0,true,1);
	audio_sound_gain(scanSound,0.375,2000);
}
else
{
	if(global.roomTrans || obj_PauseMenu.pause || obj_Player.pauseSelect)
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
	scanSpread = min(scanSpread + 0.1, 1);
	
	if(instance_exists(obj_Camera))
	{
		x += (obj_Camera.x - obj_Camera.xprevious);
		y += (obj_Camera.y - obj_Camera.yprevious);
	}
}
else
{
	scanSpread = max(scanSpread - 0.1, 0);
	
	if(scanSpread <= 0)
	{
		instance_destroy();
	}
}