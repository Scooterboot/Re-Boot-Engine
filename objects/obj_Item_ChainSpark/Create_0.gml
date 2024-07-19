/// @description Initialize
event_inherited();

itemName = "chainSpark";
itemID = 0;

itemHeader = "CHAIN SPARK";
itemDesc = "Allows Wall Jumping during Shine Spark.\n" +
"Allows downward Shine Sparking.";

isMajorItem = true;

function CollectItem(player)
{
	player.hasBoots[Boots.ChainSpark] = true;
	player.boots[Boots.ChainSpark] = true;
}