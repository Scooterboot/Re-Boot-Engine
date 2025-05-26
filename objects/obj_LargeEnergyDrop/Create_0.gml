/// @description Initialize
event_inherited();

energyGive = 25;

function OnPlayerPickup()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.energy = min(obj_Player.energy+energyGive,obj_Player.energyMax);
	}
	audio_stop_sound(snd_Pickup_EnergyDrop);
	audio_play_sound(snd_Pickup_EnergyDrop,0,false);
}