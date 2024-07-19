/// @description Initialize
event_inherited();

itemName = "grappleBeam";
itemID = 0;

itemHeader = "GRAPPLE BEAM";
itemDesc = "Select ${hudIcon_3} and press ${shootButton} to fire a Grapple Beam.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.Grapple] = true;
	player.item[Item.Grapple] = true;
}