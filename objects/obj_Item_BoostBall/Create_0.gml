/// @description Initialize
event_inherited();

itemName = "boostBall";
itemID = 0;

itemHeader = "BOOST BALL";
itemDesc = "During [sprt_Text_MiniMorph], hold ${dashButton} to charge"+"\n"+"and release to boost.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasMisc[Misc.Boost] = true;
	player.misc[Misc.Boost] = true;
}