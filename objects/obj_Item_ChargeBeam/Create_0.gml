/// @description Initialize
event_inherited();

itemName = "chargeBeam";
itemID = 0;

itemHeader = "CHARGE BEAM";
itemDesc = "Hold ${shootButton} to charge your beam\n"+"and release to fire a charge shot.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBeam[Beam.Charge] = true;
		obj_Player.beam[Beam.Charge] = true;
	}
}