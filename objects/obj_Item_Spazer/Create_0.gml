/// @description Initialize
event_inherited();

itemName = "spazer";
itemID = 0;

itemHeader = "SPAZER";
itemDesc = "Fire 3 beams at once.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.Spazer] = true;
	player.item[Item.Spazer] = true;
}