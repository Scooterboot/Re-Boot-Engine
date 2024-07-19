/// @description Initialize
event_inherited();

itemName = "dodge";
itemID = 0;

itemHeader = "ACCEL DASH";
itemDesc = "Tap ${aimLockButton} to perform a dash.\n" + "Dashing grants invulnerability.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBoots[Boots.Dodge] = true;
	player.boots[Boots.Dodge] = true;
}