/// @description Initialize
event_inherited();

frameCounterMax = 5;

missileGive = 1;

function OnPlayerPickup()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.superMissileStat = min(obj_Player.superMissileStat+missileGive,obj_Player.superMissileMax);
	}
	audio_stop_sound(snd_Pickup_MissileDrop);
	audio_play_sound(snd_Pickup_MissileDrop,0,false);
}