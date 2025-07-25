/// @description Initialize
event_inherited();

itemName = "chainSpark";
itemID = 0;

itemHeader = "CHAIN SPARK";
//itemDesc = "Allows Wall Jumping during Shine Spark.\n" +
//"Allows downward Shine Sparking.";
itemDesc = "Allows Wall Jumping during Shine Spark."

isMajorItem = true;

function CollectItem(player)
{
	player.hasItem[Item.ChainSpark] = true;
	player.item[Item.ChainSpark] = true;
}