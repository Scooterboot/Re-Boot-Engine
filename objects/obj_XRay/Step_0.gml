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