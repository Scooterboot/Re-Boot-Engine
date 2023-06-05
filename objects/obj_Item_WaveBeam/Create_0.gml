/// @description Initialize
event_inherited();

itemName = "waveBeam";
itemID = 0;

itemHeader = "WAVE BEAM";
itemDesc = "Your beam now passes through walls.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBeam[Beam.Wave] = true;
		obj_Player.beam[Beam.Wave] = true;
	}
}