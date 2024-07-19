/// @description Initialize
event_inherited();

itemName = "spaceJump";
itemID = 0;

itemHeader = "SPACE JUMP";
itemDesc = "Jump continously in the air.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBoots[Boots.SpaceJump] = true;
	player.boots[Boots.SpaceJump] = true;
}