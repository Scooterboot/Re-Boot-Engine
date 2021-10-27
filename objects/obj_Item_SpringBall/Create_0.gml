/// @description Initialize
event_inherited();

itemName = "springBall";
itemID = 0;

itemHeader = "SPRING BALL";
itemDesc = "You can now jump during [sprt_Text_MiniMorph]";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasMisc[Misc.Spring] = true;
		obj_Player.misc[Misc.Spring] = true;
	}
}