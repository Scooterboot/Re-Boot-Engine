/// @description Initialize
event_inherited();

itemName = "energyTank";
itemID = 0;

energyAmount = 100;

itemHeader = "ENERGY TANK";
itemDesc = "Maximum energy increased by "+string(energyAmount)+" units";
expanHeader = "ENERGY TANK";
expanDesc = "+"+string(energyAmount)+" Energy Capacity";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		isExpansion = (obj_Player.energyMax > 99);
		obj_Player.energyMax += energyAmount;
		obj_Player.energy = obj_Player.energyMax;
	}
}