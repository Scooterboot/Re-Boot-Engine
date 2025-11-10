/// @description Initialize
event_inherited();

itemName = "ballBomb";
itemID = 0;

itemHeader = "BOMB";
//itemDesc = "[sprt_Text_MiniPlayer] [sprt_Text_Arrow] [sprt_Text_MiniMorph] and press ${shootButton} to set.";
itemDesc = "[sprt_Text_MiniPlayer] [sprt_Text_Arrow] [sprt_Text_MiniMorph] and press ${Fire} to set.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.MBBomb] = true;
	player.item[Item.MBBomb] = true;
}