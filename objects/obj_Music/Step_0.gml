/// @description Music Logic

if(room == rm_MainMenu)
{
	with(obj_MainMenu)
	{
		if(global.musicVolume > 0)
		{
			if(!global.music_Title.IsPlaying())
			{
				global.music_Title.Play();
			}
			else
			{
				if(skipIntro)
				{
					if(global.music_Title.GetTrackPos() < 24.753)
					{
						global.music_Title.SetTrackPos(24.753);
					}
				}
				else if(global.music_Title.GetTrackPos > 25)
				{
					skipIntro = true;
				}
			
				global.music_Title.Loop();
			}
		}
		else
		{
			global.music_Title.Stop();
		}
	}
	
	global.musPrev.Stop();
	global.musCurrent.Stop();
	global.musNext.Stop();
	global.rmMusic.Stop();
}
else
{
	global.music_Title.FadeStop(225);
	
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
					global.musNext.Gain(global.musicVolume,0);
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
				global.musCurrent.Gain(global.musicVolume,0);
				global.musCurrent.Loop();
			}
		}
		
		if(playIntroFanfare)
		{
			if(!fanfarePlayed)
			{
				fanfare = audio_play_sound(mus_IntroFanfare,1,false);
				audio_sound_gain(fanfare,global.musicVolume,0);
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
				audio_sound_gain(fanfare,global.musicVolume,0);
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
}

global.musPrev.FadeStop(225);