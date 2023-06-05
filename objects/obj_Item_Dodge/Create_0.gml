/// @description Initialize
event_inherited();

itemName = "dodge";
itemID = 0;

itemHeader = "ACCEL DASH";
itemDesc = "Tap ${dashButton} to perform a dash.\n" + "Dashing grants invulnerability.";

CollectItem = function()
{
	if(instance_exists(obj_Player))
	{
		obj_Player.hasBoots[Boots.Dodge] = true;
		obj_Player.boots[Boots.Dodge] = true;
	}
}