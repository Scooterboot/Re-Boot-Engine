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
        audio_play_sound(snd_XRay_Loop,0,true);
    }
}

/*if(!audio_is_playing(snd_XRay))
{
    var snd = audio_play_sound(snd_XRay,0,true);
    audio_sound_gain(snd,0.8*global.soundVolume,0);
}*/