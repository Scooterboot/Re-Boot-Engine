/// @description Music Logic

if(room == rm_MainMenu)
{
	// main menu music something something
	
	audio_stop_sound(global.musPrev);
	audio_stop_sound(global.musCurrent);
	audio_stop_sound(global.musNext);
	audio_stop_sound(global.rmMusic);
}
else
{
	if(global.musicVolume > 0)
	{
		global.musNext = global.rmMusic;
		
		if(global.musCurrent != global.musNext)
		{
			if(global.musCurrent != noone)
			{
				audio_sound_gain(global.musCurrent,0,225);
			}
			if(!global.roomTrans)
			{
				if(global.musNext != noone)
				{
					audio_play_sound(global.musNext,1,true);
					audio_sound_gain(global.musNext,global.musicVolume,0);
				}
				global.musPrev = global.musCurrent;
				global.musCurrent = global.musNext;
			}
		}
		
		if(global.musCurrent != noone && !audio_is_playing(global.musCurrent) && !audio_is_playing(itemFanfare))
		{
			audio_play_sound(global.musCurrent,1,true);
			audio_sound_gain(global.musCurrent,global.musicVolume,0);
		}
		
		if(playItemFanfare)
		{
			if(!fanfarePlayed)
			{
				itemFanfare = audio_play_sound(mus_ItemFanfare,1,false);
				audio_sound_gain(itemFanfare,global.musicVolume,0);
				fanfarePlayed = true;
			}
			else if(audio_is_playing(itemFanfare))
			{
				if(skipItemFanfare)
				{
					audio_sound_gain(itemFanfare,0,50);
					skipItemFanfare = false;
				}
				if(audio_sound_get_gain(itemFanfare) <= 0)
				{
					audio_stop_sound(itemFanfare);
				}
				audio_pause_sound(global.musCurrent);
			}
			else
			{
				audio_resume_sound(global.musCurrent);
				playItemFanfare = false;
			}
		}
		else
		{
			fanfarePlayed = false;
			skipItemFanfare = false;
		}
	}
	else
	{
		audio_stop_sound(global.musPrev);
		audio_stop_sound(global.musCurrent);
		audio_stop_sound(global.musNext);
		audio_stop_sound(global.rmMusic);
	}
}

if(audio_is_playing(global.musPrev) && audio_sound_get_gain(global.musPrev) <= 0)
{
	audio_stop_sound(global.musPrev);
}