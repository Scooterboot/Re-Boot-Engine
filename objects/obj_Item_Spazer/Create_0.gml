/// @description Initialize
event_inherited();

itemName = "spazer";
itemID = 0;

itemHeader = "SPAZER";
itemDesc = "Fire 3 beams at once";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBeam[Beam.Spazer] = true;
		obj_Player.beam[Beam.Spazer] = true;
	}
}