/// @description Initialize
event_inherited();

itemName = "plasmaBeam";
itemID = 0;

itemHeader = "PLASMA BEAM";
itemDesc = "Your beam now pierces enemies.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.PlasmaBeam] = true;
	player.item[Item.PlasmaBeam] = true;
}