/// @description Initialize
event_inherited();

itemName = "springBall";
itemID = 0;

itemHeader = "SPRING BALL";
itemDesc = "You can now jump during [sprt_Text_MiniMorph]";

isMajorItem = true;

function CollectItem(player)
{
	player.hasMisc[Misc.Spring] = true;
	player.misc[Misc.Spring] = true;
}