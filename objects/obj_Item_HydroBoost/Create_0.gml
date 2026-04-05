/// @description Initialize
event_inherited();

itemName = "hydroBoost";
//itemID = 0;

itemHeader = "HYDRO BOOST";
itemDesc = "Grants increased movement in liquid.\n" + "Tap ${Dodge} to perform a boost in any direction.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.HydroBoost] = true;
	player.item[Item.HydroBoost] = true;
}