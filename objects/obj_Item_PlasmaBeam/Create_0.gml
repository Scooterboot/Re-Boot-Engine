/// @description Initialize
event_inherited();

itemName = "plasmaBeam";
itemID = 0;

itemHeader = "PLASMA BEAM";
itemDesc = "Your beam now pierces enemies.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBeam[Beam.Plasma] = true;
	player.beam[Beam.Plasma] = true;
}