/// @description Initialize
event_inherited();

itemName = "spaceJump";
itemID = 0;

itemHeader = "SPACE JUMP";
itemDesc = "Jump continously in the air.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.SpaceJump] = true;
		obj_Player.boots[Boots.SpaceJump] = true;
	}
}