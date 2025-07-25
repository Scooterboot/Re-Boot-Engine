/// @description Initialize
event_inherited();

itemName = "powerGrip";
itemID = 0;

itemHeader = "POWER GRIP";
itemDesc = "Grab and hang from ledges and corners.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.PowerGrip] = true;
	player.item[Item.PowerGrip] = true;
}