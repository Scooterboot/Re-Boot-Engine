/// @description Initialize
event_inherited();

itemName = "dodge";
itemID = 0;

itemHeader = "ACCEL DASH";
//itemDesc = "Tap ${aimLockButton} to perform a dash.\n" + "Dashing grants invulnerability.";
itemDesc = "Tap ${Dodge} to perform a dash.\n" + "Dashing grants invulnerability.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.AccelDash] = true;
	player.item[Item.AccelDash] = true;
}