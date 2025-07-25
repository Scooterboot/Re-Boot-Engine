/// @description Initialize
event_inherited();

itemName = "boostBall";
itemID = 0;

itemHeader = "BOOST BALL";
itemDesc = "During [sprt_Text_MiniMorph], hold ${sprintButton} to charge"+"\n"+"and release to boost.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.BoostBall] = true;
	player.item[Item.BoostBall] = true;
}