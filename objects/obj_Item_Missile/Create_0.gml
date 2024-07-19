/// @description Initialize
event_inherited();

itemName = "missileTank";
itemID = 0;

missileAmount = 5;

itemHeader = "MISSILE";
//itemDesc = "Select it and press [Shoot]";
itemDesc = "Select ${hudIcon_0} and press ${shootButton} to fire a Missile.";
expanHeader = "MISSILE EXPANSION";
expanDesc = "+"+string(missileAmount)+" Missile Capacity";

function CollectItem(player)
{
	isExpansion = (player.hasItem[Item.Missile]);
	player.hasItem[Item.Missile] = true;
	player.item[Item.Missile] = true;
	player.missileMax += missileAmount;
	player.missileStat += missileAmount;
}