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

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		isExpansion = (obj_Player.hasItem[Item.Missile]);
		obj_Player.hasItem[Item.Missile] = true;
		obj_Player.item[Item.Missile] = true;
		obj_Player.missileMax += missileAmount;
		obj_Player.missileStat += missileAmount;
	}
}