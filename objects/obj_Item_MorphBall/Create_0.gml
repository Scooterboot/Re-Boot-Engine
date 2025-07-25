/// @description Initialize
event_inherited();

itemName = "morphBall";
itemID = 0;

itemHeader = "MORPH BALL";
itemDesc = "Press ${controlPad} down twice to morph into a ball.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.MorphBall] = true;
	player.item[Item.MorphBall] = true;
}