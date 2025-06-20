/// @description Initialize
event_inherited();

itemName = "magniBall";
itemID = 0;

itemHeader = "MAGNI BALL";
itemDesc = "Press ${angleUpButton} or ${angleDownButton} during [sprt_Text_MiniMorph] to climb magnetic tracks.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasMisc[Misc.MagBall] = true;
	player.misc[Misc.MagBall] = true;
}