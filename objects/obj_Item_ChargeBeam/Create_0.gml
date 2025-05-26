/// @description Initialize
event_inherited();

itemName = "chargeBeam";
itemID = 0;

itemHeader = "CHARGE BEAM";
itemDesc = "Hold ${shootButton} to charge your beam\n"+"and release to fire a charge shot.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBeam[Beam.Charge] = true;
	player.beam[Beam.Charge] = true;
}