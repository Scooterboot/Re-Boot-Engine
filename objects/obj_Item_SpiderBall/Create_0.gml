/// @description Initialize
event_inherited();

itemName = "spiderBall";
itemID = 0;

itemHeader = "SPIDER BALL";
itemDesc = "Press ${angleUpButton} or ${angleDownButton} during [sprt_Text_MiniMorph] to climb walls";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.Spider] = true;
		obj_Player.misc[Misc.Spider] = true;
	}
}