/// @description Initialize
event_inherited();

frameCounterMax = 5;

bombGive = 1;

function OnPlayerPickup()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.powerBombStat = min(obj_Player.powerBombStat+bombGive,obj_Player.powerBombMax);
	}
	audio_stop_sound(snd_Pickup_MissileDrop);
	audio_play_sound(snd_Pickup_MissileDrop,0,false);
}