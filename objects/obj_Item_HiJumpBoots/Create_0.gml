/// @description Initialize
event_inherited();

itemName = "hiJump";
itemID = 0;

itemHeader = "HI-JUMP BOOTS";
itemDesc = "Jump height increased.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.HiJump] = true;
		obj_Player.boots[Boots.HiJump] = true;
	}
}