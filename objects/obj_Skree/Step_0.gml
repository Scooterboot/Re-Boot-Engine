/// @description 
event_inherited();
if(self.PauseAI())
{
	exit;
}

if(state == 0) // idle
{
	frameCounter++;
	if(frameCounter > 6)
	{
		frame = scr_wrap(frame+1,0,4);
		frameCounter = 0;
	}
}
if(state == 1) // alerted
{
	frame = 4;
	frameCounter = 0;
}
if(state >= 2) // dive & dig
{
	frameCounter++;
	if(frameCounter > 1)
	{
		frame = scr_wrap(frame+1,0,4);
		frameCounter = 0;
	}
	
	if(!diveSoundPlayed)
	{
		audio_play_sound(snd_Skree_V,0,false);
		diveSoundPlayed = true;
	}
	if(state == 3 && !digSoundPlayed)
	{
		audio_play_sound(snd_Skree_Land,0,false);
		digSoundPlayed = true;
	}
}

image_index = frame;