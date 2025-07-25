/// @description Initialize
event_inherited();

itemName = "spaceJump";
itemID = 0;

itemHeader = "SPACE JUMP";
itemDesc = "Jump continously in the air.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.SpaceJump] = true;
	player.item[Item.SpaceJump] = true;
}