/// @description Sound
global.gamePaused = true;

if(!audio_is_playing(snd_XRay_Loop))
{
    if(!xRaySoundPlayed)
    {
        audio_play_sound(snd_XRay,0,false);
        xRaySoundPlayed = true;
    }
    else if(!audio_is_playing(snd_XRay))
    {
        xRaySound = audio_play_sound(snd_XRay_Loop,0,true,1);
		audio_sound_gain(xRaySound,0.375,2000);
    }
}
else
{
	if(global.roomTrans || obj_PauseMenu.pause || obj_Player.pauseSelect)
	{
		audio_pause_sound(snd_XRay);
		audio_pause_sound(snd_XRay_Loop);
	}
	else
	{
		audio_resume_sound(snd_XRay);
		audio_resume_sound(snd_XRay_Loop);
	}
}

if(!kill)
{
	coneSpread = min(coneSpread + 2, coneSpreadMax);
}
else
{
    coneSpread = max(coneSpread - 2, 0);
    
    if (coneSpread <= 0)
    {
        instance_destroy();
    }
}