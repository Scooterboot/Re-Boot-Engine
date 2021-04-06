audio_stop_sound(snd_GrappleBeam_Loop);
audio_stop_sound(snd_GrappleBeam_Shoot);
if(!global.gamePaused)
{
    audio_play_sound(snd_GrappleBeam_End,0,false);
}