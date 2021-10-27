/// @description Initialize
event_inherited();

itemName = "chainSpark";
itemID = 0;

itemHeader = "CHAIN SPARK";
itemDesc = "Wall Jump during Shine Spark\n" +
"Allows downward Shine Sparking";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.ChainSpark] = true;
		obj_Player.boots[Boots.ChainSpark] = true;
	}
}