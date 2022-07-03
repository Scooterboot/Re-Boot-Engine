/// @description Initialize
event_inherited();

frameCounterMax = 5;

missileGive = 2;

function OnPlayerPickup()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.missileStat = min(obj_Player.missileStat+missileGive,obj_Player.missileMax);
	}
	audio_stop_sound(snd_Pickup_MissileDrop);
	audio_play_sound(snd_Pickup_MissileDrop,0,false);
}