/// @description Initialize
event_inherited();

itemName = "hiJump";
itemID = 0;

itemHeader = "HI-JUMP BOOTS";
itemDesc = "Jump height increased.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.HiJump] = true;
	player.item[Item.HiJump] = true;
}