/// @description Lava Movement

if(!global.gamePaused)
{
    if (btm <= abs(bspd))
    {
        acc *= -1;
    }
    
    if (Move)
    {
        bspd += acc;
        y += bspd;
    }
    
    if(sign(MoveX) == 1)
    {
        x = scr_Loop(x+MoveX,0,sprite_width);
    }
    if(sign(MoveX) == -1)
    {
        x = scr_Loop(x+MoveX,-sprite_width,0);
    }
 
    Gradient.y = y - 32;

    if(!audio_is_playing(snd_LavaLoop))
    {
        var loopSnd = audio_play_sound(snd_LavaLoop,0,true);
        audio_sound_gain(loopSnd,0.9*global.soundVolume,0);
    }
}