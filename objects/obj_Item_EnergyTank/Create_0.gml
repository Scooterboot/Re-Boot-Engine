/// @description Initialize
event_inherited();

itemName = "energyTank";
itemID = 0;

energyAmount = 100;

itemHeader = "ENERGY TANK";
itemDesc = "Maximum energy increased by "+string(energyAmount)+" units.";
expanHeader = "ENERGY TANK";
expanDesc = "+"+string(energyAmount)+" Energy Capacity";

function CollectItem(player)
{
	isExpansion = (player.energyMax > 99);
	player.energyMax += energyAmount;
	player.energy = obj_Player.energyMax;
}