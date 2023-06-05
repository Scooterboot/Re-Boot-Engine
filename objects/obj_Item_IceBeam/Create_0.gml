/// @description Initialize
event_inherited();

itemName = "iceBeam";
itemID = 0;

itemHeader = "ICE BEAM";
itemDesc = "Your beam can now freeze most enemies.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBeam[Beam.Ice] = true;
		obj_Player.beam[Beam.Ice] = true;
	}
}