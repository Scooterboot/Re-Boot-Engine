/// @description Initialize
event_inherited();

itemName = "superMissileTank";
itemID = 0;

sMissileAmount = 5;

itemHeader = "SUPER MISSILE";
//itemDesc = "Select it and press [Shoot]";
itemDesc = "Select ${hudIcon_1} and press ${shootButton} to fire";
expanHeader = "SUPER MISSILE EXPANSION";
expanDesc = "+"+string(sMissileAmount)+" Super Missile Capacity";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		isExpansion = (obj_Player.hasItem[Item.SMissile]);
		obj_Player.hasItem[Item.SMissile] = true;
		obj_Player.item[Item.SMissile] = true;
		obj_Player.superMissileMax += sMissileAmount;
		obj_Player.superMissileStat += sMissileAmount;
	}
}