/// @description Initialize
event_inherited();

itemName = "plasmaBeam";
itemID = 0;

itemHeader = "PLASMA BEAM";
itemDesc = "Your beam now pierces enemies";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBeam[Beam.Plasma] = true;
		obj_Player.beam[Beam.Plasma] = true;
	}
}