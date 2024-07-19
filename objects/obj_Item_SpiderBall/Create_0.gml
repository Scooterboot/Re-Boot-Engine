/// @description Initialize
event_inherited();

itemName = "spiderBall";
itemID = 0;

itemHeader = "SPIDER BALL";
itemDesc = "Press ${angleUpButton} or ${angleDownButton} during [sprt_Text_MiniMorph] to climb walls.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasMisc[Misc.Spider] = true;
	player.misc[Misc.Spider] = true;
}