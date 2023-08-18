/// @description 

if(room == rm_MainMenu)
{
	global.rmMusic = global.music_Title;
	
	if(global.musicVolume > 0 && global.musCurrent == global.musNext && global.musCurrent.IsPlaying())
	{
		with(obj_MainMenu)
		{
			if(skipIntro)
			{
				if(global.musCurrent.GetTrackPos() < 24.753)
				{
					global.musCurrent.SetTrackPos(24.753);
				}
			}
			else if(global.musCurrent.GetTrackPos > 25)
			{
				skipIntro = true;
			}
		}
	}
}
	
if(global.musicVolume > 0)
{
	global.musNext = global.rmMusic;
		
	if(global.musCurrent != global.musNext)
	{
		if(global.musCurrent != noone && global.musCurrent.song != noone)
		{
			global.musCurrent.Gain(0,225);
		}
		if(!global.roomTrans)
		{
			if(global.musNext != noone && global.musNext.song != noone)
			{
				global.musNext.Play();
				global.musNext.Gain(1,0);
			}
			global.musPrev = global.musCurrent;
			global.musCurrent = global.musNext;
		}
	}
	else if(global.musCurrent != noone && global.musCurrent.song != noone && !audio_is_playing(fanfare))
	{
		if(!global.musCurrent.IsPlaying())
		{
			global.musCurrent.Play();
		}
		else
		{
			global.musCurrent.Gain(1,0);
			global.musCurrent.Loop();
		}
	}
		
	if(playIntroFanfare)
	{
		if(!fanfarePlayed)
		{
			fanfare = audio_play_sound(mus_IntroFanfare,1,false);
			audio_sound_gain(fanfare,1,0);
			fanfarePlayed = true;
		}
		else if(audio_is_playing(fanfare))
		{
			if(skipIntroFanfare)
			{
				audio_sound_gain(fanfare,0,50);
				skipIntroFanfare = false;
			}
			if(audio_sound_get_gain(fanfare) <= 0)
			{
				audio_stop_sound(fanfare);
			}
			global.musCurrent.Pause();
		}
		else
		{
			global.musCurrent.Resume();
			playIntroFanfare = false;
		}
			
		skipItemFanfare = false;
	}
	else if(playItemFanfare)
	{
		if(!fanfarePlayed)
		{
			fanfare = audio_play_sound(mus_ItemFanfare,1,false);
			audio_sound_gain(fanfare,1,0);
			fanfarePlayed = true;
		}
		else if(audio_is_playing(fanfare))
		{
			if(skipItemFanfare)
			{
				audio_sound_gain(fanfare,0,50);
				skipItemFanfare = false;
			}
			if(audio_sound_get_gain(fanfare) <= 0)
			{
				audio_stop_sound(fanfare);
			}
			global.musCurrent.Pause();
		}
		else
		{
			global.musCurrent.Resume();
			playItemFanfare = false;
		}
			
		skipIntroFanfare = false;
	}
	else
	{
		fanfarePlayed = false;
		skipItemFanfare = false;
		skipIntroFanfare = false;
	}
}
else
{
	global.musPrev.Stop();
	global.musCurrent.Stop();
	global.musNext.Stop();
	global.rmMusic.Stop();
		
	fanfarePlayed = false;
	playIntroFanfare = false;
	playItemFanfare = false;
	skipIntroFanfare = false;
	skipItemFanfare = false;
}

global.musPrev.FadeStop(225);


if(room == rm_MainMenu || room == rm_GameOver)
{
	global.SilenceAudio();
}
else if(global.gamePaused)
{
	for(var i = 0; i < array_length(sndPauseArray); i++)
	{
		audio_pause_sound(sndPauseArray[i]);
	}
}
else
{
	for(var i = 0; i < array_length(sndPauseArray); i++)
	{
		audio_resume_sound(sndPauseArray[i]);
	}
}

global.breakSndCounter = max(global.breakSndCounter-1,0);