/// @description Initialize
event_inherited();

itemName = "magniBall";
itemID = 0;

itemHeader = "MAGNI BALL";
//itemDesc = "Press ${angleUpButton} or ${angleDownButton} during [sprt_Text_MiniMorph] to climb magnetic tracks.";
itemDesc = "Press ${SpiderBall} during [sprt_Text_MiniMorph] to climb magnetic tracks.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.MagniBall] = true;
	player.item[Item.MagniBall] = true;
}