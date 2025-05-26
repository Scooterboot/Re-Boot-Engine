/// @description Initialize
event_inherited();

itemName = "hiJump";
itemID = 0;

itemHeader = "HI-JUMP BOOTS";
itemDesc = "Jump height increased.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBoots[Boots.HiJump] = true;
	player.boots[Boots.HiJump] = true;
}