/// @description Initialize
event_inherited();

itemName = "iceBeam";
itemID = 0;

itemHeader = "ICE BEAM";
itemDesc = "Your beam can now freeze most enemies.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.IceBeam] = true;
	player.item[Item.IceBeam] = true;
}