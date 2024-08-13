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
        xRaySound = audio_play_sound(snd_XRay_Loop,0,true,global.soundVolume);
		audio_sound_gain(xRaySound,global.soundVolume*0.5,1000);
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