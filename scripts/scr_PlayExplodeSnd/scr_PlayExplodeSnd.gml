///scr_PlayExplodeSnd(priority,loops)
function scr_PlayExplodeSnd(priority, loops) {

	if(audio_is_playing(global.prevExplodeSnd))
	{
	    audio_sound_gain(global.prevExplodeSnd,0,25);
	}
	var snd = audio_play_sound(snd_Explode,priority,loops);
	audio_sound_gain(snd,1,0);
	global.prevExplodeSnd = snd;

	global.breakSndCounter = 5;


}
