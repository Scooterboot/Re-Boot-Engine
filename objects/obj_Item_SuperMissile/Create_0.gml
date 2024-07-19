/// @description Initialize
event_inherited();

itemName = "superMissileTank";
itemID = 0;

sMissileAmount = 5;

itemHeader = "SUPER MISSILE";
//itemDesc = "Select it and press [Shoot]";
itemDesc = "Select ${hudIcon_1} and press ${shootButton} to fire a Super Missile.";
expanHeader = "SUPER MISSILE EXPANSION";
expanDesc = "+"+string(sMissileAmount)+" Super Missile Capacity";

function CollectItem(player)
{
	isExpansion = (player.hasItem[Item.SMissile]);
	player.hasItem[Item.SMissile] = true;
	player.item[Item.SMissile] = true;
	player.superMissileMax += sMissileAmount;
	player.superMissileStat += sMissileAmount;
}