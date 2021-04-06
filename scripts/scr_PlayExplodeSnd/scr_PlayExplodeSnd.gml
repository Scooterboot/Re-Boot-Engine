///scr_PlayExplodeSnd(priority,loops)
function scr_PlayExplodeSnd(argument0, argument1) {

	if(audio_is_playing(global.prevExplodeSnd))
	{
	    audio_sound_gain(global.prevExplodeSnd,0,25);
	}
	var snd = audio_play_sound(snd_Explode,argument0,argument1);
	audio_sound_gain(snd,global.soundVolume,0);
	global.prevExplodeSnd = snd;

	global.breakSndCounter = 5;


}
