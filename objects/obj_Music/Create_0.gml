/// @description Initialize
playItemFanfare = false;
skipItemFanfare = false;
fanfare = noone;
fanfarePlayed = false;

playIntroFanfare = false;
skipIntroFanfare = false;

#region LoopedSong struct
function LoopedSong(_snd, _loopStart, _loopEnd) constructor
{
	songID = _snd;
	loopStart = _loopStart;
	loopEnd = _loopEnd;
	loopLength = loopEnd-loopStart;
	
	song = songID;
	function Play()
	{
		var priority = 1,
			loops = true;
		if(argument_count > 0)
		{
			priority = argument[0];
		}
		if(argument_count > 1)
		{
			loops = argument[1];
		}
		song = audio_play_sound(songID,priority,loops);
		audio_sound_gain(song,global.musicVolume,0);
		return song;
	}
	function IsPlaying() { return audio_is_playing(song); }
	function Stop() { audio_stop_sound(song); }
	function Pause() { audio_pause_sound(song); }
	function Resume() { audio_resume_sound(song); }
	function GetTrackPos() { return audio_sound_get_track_position(song); }
	function SetTrackPos(time) { audio_sound_set_track_position(song,time); }
	function Loop()
	{
		if(IsPlaying() && loopEnd > 0)
		{
			var songPos = GetTrackPos();
			if(songPos >= loopEnd)
			{
				SetTrackPos(songPos-loopLength);
			}
		}
	}
	function Gain(level,time) { audio_sound_gain(song,level,time); }
	function GetGain() { return audio_sound_get_gain(song); }
	
	gainSet = false;
	function FadeStop(time)
	{
		if(IsPlaying())
		{
			if(!gainSet)
			{
				Gain(-1,time);
				gainSet = true;
			}
			if(GetGain() <= 0)
			{
				Stop();
				gainSet = false;
			}
		}
		else
		{
			gainSet = false;
		}
	}
}
#endregion

global.rmMusic = new LoopedSong(noone,0,0);
global.musPrev = new LoopedSong(noone,0,0);
global.musCurrent = new LoopedSong(noone,0,0);
global.musNext = new LoopedSong(noone,0,0);

global.SilenceMusic = function()
{
	global.rmMusic = new LoopedSong(noone,0,0);
}

global.music_Title = new LoopedSong(mus_Title, 58.090, 90.858);
global.music_ItemRoom = new LoopedSong(mus_ItemRoom, 13.962, 34.698);
global.music_AmbientSilence = new LoopedSong(mus_AmbientSilence, 10.562, 27.901);
global.music_CrateriaMain = new LoopedSong(mus_CrateriaMain, 28.602, 238.914);
global.music_BrinstarGreen = new LoopedSong(mus_BrinstarGreen, 64.806, 166.750);
global.music_BrinstarRed = new LoopedSong(mus_BrinstarRed, 106.264, 218.838);
global.music_UpperNorfair = new LoopedSong(mus_UpperNorfair, 49.169, 107.423);